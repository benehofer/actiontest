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
        $destinationData=Convert-wupBody -source $sourceData -sourceType $syncJob.sourcetype -recordType $syncJob.recordtype -destinationType "snow"
        #if ($null -eq $destinationData) {$destinationData=@()}
        $syncJob | Add-Member -MemberType NoteProperty -Name "_destinationData" -Value $destinationData
        $r=Get-wupSnowAuthHeader | Write-Result
    }
    if ($r.Success) {
        $snowHeader=$r.Value
        $destinationUrl=$(Invoke-Command([scriptblock]::Create("`$global:snowurl$($syncJob.recordType)")))
        $syncJob | Add-Member -MemberType NoteProperty -Name "_destinationUrl" -Value $destinationUrl
        if ($destinationData.Length -gt 0) {
            $r=Set-wupSNOWData -snowHeader $snowHeader -url $destinationUrl -data $destinationData | Write-Result
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
        $r=New-Result -success $true -message "Successfully executed SNOW queueworker [$($syncJob.RowKey)]" -value $destinationData -logLevel Information
    }
} catch {
    $r=New-Result -success $false -message "Error processing SNOW queueworker" -exception $_.exception -logLevel Error
}
$r | Write-Result -NoPassThru
if ($r.Success) {
    
} else {
    throw $($r.message)
}
