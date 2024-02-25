<#
<DOC>
The business central (bc) queue worker transfers data to the Business Central system. 
As with all worker processes, the synjob data is first loaded from the queue and the 
blob storage. The source data record within the syncjob data is then converted into 
the target format (destinationData) and the synjob is supplemented with this 
destinationData record.<br/>Depending on the syncjob type (recordtype), the data is then 
transferred to the BC system. The bc queue worker is currently equipped for data records 
of the type "journal".<br/>The worker is designed to transfer entire arrays of journal 
data records to BC. Due to the interface logic, each data record must be transferred 
individually. The API of the BC system is subject to operational limits (see also the 
following <a href='https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/api-reference/v1.0/dynamics-current-limits' target='_blank'>article</a>). 
The WIDup interface therefore transfers the data in several batches; the number of journal 
records specified in the 'bcQueueBatchSize' parameter is transferred for each individual 
batch. The current cursor position is then saved in the syncJob data record (journalCursor) 
and the synjob data record is re-inserted into the bc-queue. During the next processing, 
the transfer is continued at the 'journalCursor' position. This process is repeated until 
all data has been transferred.<br/>Finally, the syncjob data record is passed on to the 
next queue (dvqueue) and the original blob is deleted on successful completion <section:queue worker processing>.
</DOC>
#>
param([object]$QueueItem, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    $queueEntry=$QueueItem | convertto-json -depth 100 | convertfrom-json -depth 100
    $r=Get-wupQueueMessage -queueEntry $queueEntry | Write-Result
    if ($r.Success) {
        $syncJob=$r.Value
        $r=Get-wupApiSchema | Write-Result
    }
    if ($r.Success) {
        $sourceData=$syncJob._sourceData
        if (($syncjob.psobject.Properties | select -ExpandProperty name) -notcontains "_destinationdata") {
            $destinationData=Convert-wupBody -source $sourceData -sourceType $syncJob.sourcetype -recordType $syncJob.recordtype -destinationType "bc"
            $syncJob | Add-Member -MemberType NoteProperty -Name "_destinationData" -Value $destinationData
        } else {
            $destinationData=$syncJob._destinationData
        }
        $r=Get-wupBCAuthHeader | Write-Result
    }
    if ($r.Success) {
        $bcHeader=$r.Value
        if (($syncjob.psobject.Properties | select -ExpandProperty name) -notcontains "_destinationUrl") {
            $destinationUrl=$(Invoke-Command([scriptblock]::Create("`$global:bcurl$($syncJob.recordType)")))
            $syncJob | Add-Member -MemberType NoteProperty -Name "_destinationUrl" -Value $destinationUrl
        } else {
            $destinationUrl=$syncJob._destinationUrl
        }

        switch ($syncJob.recordtype) {
            "journal" {
                if ($null -eq $syncJob._journalcursor) {$journalCursor=0} else {$journalCursor=$syncJob._journalcursor}
                $r=New-Result -success $true -message "Journal batch starting at record [$($journalCursor)/$($destinationData.length)]" | Write-Result
                $destinationData[$journalCursor..($journalCursor+($global:bcQueueBatchSize))] | %{
                    if ($r.Success) {
                        $drec=$_
                        $r=Set-wupBCJournalData -record $drec -bcHeader $bcHeader | Write-Result
                    }
                }
                if ($r.Success) {
                    $journalCursor+=($global:bcQueueBatchSize)
                    $syncJob | Add-Member -MemberType NoteProperty -Name "_journalcursor" -Value $journalCursor -Force
                    $r=New-Result -success $true -message "Journal batch processed to record [$($journalCursor)/$($destinationData.length)]" | Write-Result
                    if ($journalCursor -ge $destinationData.Length) {
                        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:dvqueuename | Write-Result
                    } else {
                        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:bcQueueName | Write-Result
                    }    
                }
                break
            }
            "ticket" {
                if ($null -eq $syncJob._ticketcursor) {$ticketCursor=0} else {$ticketCursor=$syncJob._ticketcursor}
                $r=New-Result -success $true -message "Ticket batch starting at record [$($ticketCursor)/$($destinationData.length)]" | Write-Result
                $destinationData[$ticketCursor..($ticketCursor+($global:bcQueueBatchSize))] | %{
                    if ($r.Success) {
                        $drec=$_
                        $r=Set-wupBCTicketData -record $drec -bcHeader $bcHeader | Write-Result
                    }
                }
                if ($r.Success) {
                    $ticketCursor+=($global:bcQueueBatchSize)
                    $syncJob | Add-Member -MemberType NoteProperty -Name "_ticketcursor" -Value $ticketCursor -Force
                    $r=New-Result -success $true -message "Ticket batch processed to record [$($ticketCursor)/$($destinationData.length)]" | Write-Result
                    if ($ticketCursor -ge $destinationData.Length) {
                        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:dvqueuename | Write-Result
                    } else {
                        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:bcQueueName | Write-Result
                    }    
                }
                break                
            }
            default {}
        }
    }
    if ($r.Success) {
        $r=Remove-wupQueueMessage -queueEntry $queueEntry | Write-Result
    }
    if ($r.Success) {
        $r=New-Result -success $true -message "Successfully executed BC queueworker [$($syncJob.RowKey)]" -value $destinationData -logLevel Information
    }
} catch {
    $r=New-Result -success $false -message "Error processing BC queueworker" -exception $_.exception -logLevel Error
}
$r | Write-Result -NoPassThru
if ($r.Success) {
    
} else {
    throw $($r.message)
}
