ipmo '.\Azure Functions\Modules\widtools\widtools.psm1' -force
ipmo '.\Azure Functions\Modules\widup\widup.psm1' -force
"Starting" 
$r=Get-wupApiSchema | Write-Result
$queueEntry=Get-ItemFromQueue -queueName "$($global:bcQueueName)-poison" -doNotDeleteMessage
"Record is: $($queueEntry.blobID)"
$r=Get-wupQueueMessage -queueEntry $queueEntry | Write-Result
$syncJob=$r.Value
$sourceData=$syncJob._sourceData
"Source data:"
$sourceData | Out-String
$destinationData=Convert-wupBody -source $sourceData -sourceType $syncJob.sourcetype -recordType $syncJob.recordtype -destinationType "bc"
"Destination data:"
$destinationData | Out-String
$record=$destinationData[0]

$r=Get-wupBCAuthHeader | Write-Result
$bcHeader=$r.Value
$r=Set-wupBCURLJobworksheet -bcHeader $bcHeader
$r=Get-wupBCData -bcHeader $bcHeader -url $global:bcurljobworksheet -filter "(wagGUIDNOW eq '$($record.WAGGUIDNOW)')"
$bcJournalData=$r.Value | ? {$_.WAGStorno -eq $false}
if ($null -eq $bcJournalData) {
    "No existing record found in BC jobWorkSheet"

    $r=Get-wupBCData -bcHeader $bcHeader -url $global:bcurljobledger -filter "(wagGUIDNOW eq '$($record.WAGGUIDNOW)')"
    $bcLedgerData=$r.Value | ? {$_.WAGStorno -eq $false}
    if ($null -ne $bcLedgerData) {
        "Existing record found in BC ledger"
    } else {
        "No existing record found in BC ledger"
    }
} else {
    "Existing record found in BC $($bcJournalData[0].systemid)"
}

"Sending record to BC:"
$r=Set-wupBCJournalData -record $record -bcHeader $bcHeader
$r.Message

