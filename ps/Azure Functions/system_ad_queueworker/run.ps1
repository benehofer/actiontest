# Input bindings are passed in via param block.
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
