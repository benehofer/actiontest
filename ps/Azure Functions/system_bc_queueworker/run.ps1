# Input bindings are passed in via param block.
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
