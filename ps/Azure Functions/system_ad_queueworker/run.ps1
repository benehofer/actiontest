<#
<DOC>
The queue worker for the Active Directory Domain Services System creates and modifies 
user accounts and groups in the local (legacy) Active Directory system.<br/>The worker 
receives the QueueItem via the queue trigger, which contains the reference to the blob 
in which the current syncjob object with the source data is stored.<br/>The worker first 
loads this data and converts it into the target structure (destinationData); The syncjob 
dataset is extended with the destinationData dataset<br/>The worker then establishes 
a remote session to a local target server in the Active Directory via the hybrid connection. 
Within this session, the worker executes Powershell commands remotely on the ADDS server, 
to manage the user accounts, groups and memberships.<br/>Finally, the worker inserts the 
new data record into the next queue (dvQueue) and deletes the original blob <section:queue worker processing>. 
</DOC>
#>
param([object]$QueueItem, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    #$syncJob=$QueueItem | convertto-json -depth 100 | convertfrom-json -depth 100
    $queueEntry=$QueueItem | convertto-json -depth 100 | convertfrom-json -depth 100
    $r=Get-wupQueueMessage -queueEntry $queueEntry | Write-Result

    if ($r.Success) {
        $syncJob=$r.Value
        $r=Get-wupApiSchema | Write-Result
    }
    if ($r.Success) {
        $sourceData=$syncJob._sourceData
        $destinationData=Convert-wupBody -source $sourceData -sourceType $syncJob.sourcetype -recordType $syncJob.recordtype -destinationType "ad"
        $syncJob | Add-Member -MemberType NoteProperty -Name "_destinationData" -Value $destinationData
        if ($destinationData.Length -gt 0) {
            
            $r=Get-wupVaultSecret -secretName $global:adusernamekvsecretname -vaultUrl $global:vaultUrl | Write-Result
            if ($r.Success) {    
                $ADUserName=$r.Value.Value
                $r=Get-wupVaultSecret -secretName $global:aduserpasswordkvsecretname -vaultUrl $global:vaultUrl | Write-Result
            }
            if ($r.Success) {
                $ADUserPassword=$r.Value.value
                $credential=New-Object -TypeName pscredential -ArgumentList $ADUserName,($ADUserPassword | ConvertTo-SecureString -AsPlainText -Force)
                $r=Get-wupADServerSession -credential $credential | Write-Result
            }
            if ($r.Success) {
                $session=$r.Value
                $destinationData | % {
                    $record=$_
                    if ($r.Success) {
                        $r=$(Invoke-Command([scriptblock]::Create("Invoke-wupADServerCommand$($syncJob.recordtype)  -record `$record -credential `$credential -session `$session | Write-Result")))
                        #$r=Invoke-wupADServerCommandEmployee -record $record -credential $credential -session $session | Write-Result
                    }
                }
            }
        } else {
            $r=New-Result -success $true -message "No records to insert/update" -logLevel Information | Write-Result
        }
    }
    if ($r.Success) {
        $queueName=$global:dvqueuename
        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $queuename | Write-Result
    }

    if ($r.Success) {
        $r=Remove-wupQueueMessage -queueEntry $queueEntry | Write-Result
    }
    if ($r.Success) {
        $r=New-Result -success $true -message "Successfully executed AD queueworker [$($syncJob.RowKey)]" -value $destinationData -logLevel Information
    }
} catch {
    $r=New-Result -success $false -message "Error processing AD queueworker" -exception $_.exception -logLevel Error
}
$r | Write-Result -NoPassThru
if ($r.Success) {
    
} else {
    throw $($r.message)
}
