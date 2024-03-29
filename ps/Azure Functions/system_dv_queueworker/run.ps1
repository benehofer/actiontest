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
        $dvData=Convert-wupBody -source $sourceData -sourceType $syncJob.sourcetype -recordType $syncJob.recordtype -destinationType "dv"
        $syncJob | Add-Member -MemberType NoteProperty -Name "_dvData" -Value $dvData
        $r=Get-wupDVAuthHeader | Write-Result
    }
    if ($r.Success) {
        $dvHeader=$r.Value
        $dvUrl=$(Invoke-Command([scriptblock]::Create("`$global:dvurl$($syncJob.recordType)")))
        $syncJob | Add-Member -MemberType NoteProperty -Name "_dvUrl" -Value $dvUrl
        if ($dvData.Length -gt 0) {
            $r=Set-wupDVData -dvHeader $dvHeader -url $dvUrl -recordType $syncJob.recordType -data $dvData | Write-Result
        } else {
            $r=New-Result -success $true -message "No records to insert/update" -logLevel Information | Write-Result
        }
    }
    if ($r.Success) {
        $queueName=$global:jobQueueName
        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $queuename | Write-Result
    }
    if ($r.Success) {
        $r=Remove-wupQueueMessage -queueEntry $queueEntry | Write-Result
    }
    if ($r.Success) {
        $r=New-Result -success $true -message "Successfully executed DV queueworker [$($syncJob.RowKey)]" -value $destinationData -logLevel Information
    }
} catch {
    $r=New-Result -success $false -message "Error processing DV queueworker" -exception $_.exception -logLevel Error | Write-Result
}
$r | Write-Result -NoPassThru
if ($r.Success) {
    
} else {
    throw $($r.message)
}
