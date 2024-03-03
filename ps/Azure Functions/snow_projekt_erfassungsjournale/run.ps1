<#
<DOC>
The function implements an http trigger, i.e. a REST function for receiving timecard data records from the Snow 
system. Note: The original term for TimeCards was "capture journals", hence the technical name of the function.
<br/>The function receives data records from the Service Now system and inserts them into the bcqueue 
<article:widup queue processing>. <br/>From each incoming timecard record, two queue entries are made with 
two different data record types, one for the timecard itself and one for the meta information about the 
ticket.<br/>The REST Api is one of the two processes that start the queue cycle <section:widup queues>.
</DOC>
#>
using namespace System.Net
param($Request, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    $body=[PSCustomObject]$Request.Body
    $httpHeaders=$Request.headers
    $returnBody=$body | ConvertTo-Json -Depth 100

    $r=Get-wupApiSchema
    if ($r.Success) {
        $syncJob=$global:schema.syncJobs | ? {$_.recordType -eq 'journal' -and $_.sourceType -eq 'snow'}
        $syncJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value 'trigger'
        $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceUrl" -Value $httpHeaders.Item('x-original-url')
        if ($($body.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -ne "Array") {
            $body=@($body)
        }      
        $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceData" -Value $body
        $syncJob | Add-Member -MemberType NoteProperty -Name "_started" -Value (get-date).ToString("s")
        $queueName=$(Invoke-Command([scriptblock]::Create("`$global:$($syncjob.destinationType)queuename")))
        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $queuename | Write-Result
    }
    
    if ($r.Success) {
        $syncJob=$global:schema.syncJobs | ? {$_.recordType -eq 'ticket' -and $_.sourceType -eq 'snow'}
        $syncJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value 'trigger'
        $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceUrl" -Value $httpHeaders.Item('x-original-url')
        if ($($body.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -ne "Array") {
            $body=@($body)
        }      
        $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceData" -Value $body
        $syncJob | Add-Member -MemberType NoteProperty -Name "_started" -Value (get-date).ToString("s")
        $queueName=$(Invoke-Command([scriptblock]::Create("`$global:$($syncjob.destinationType)queuename")))
        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $queuename | Write-Result
    }
    
    if ($r.Success) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::OK
            ContentType="text/plain"
            Body="Success"
        })
    } else {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::BadRequest
            ContentType="text/plain"
            Body="Error: $($r.Message)"
        })
    }   
} catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode=[System.Net.HttpStatusCode]::InternalServerError
        ContentType="text/plain"
        Body="Unexpected error: $($_.exception.Message)"
    })        
}
