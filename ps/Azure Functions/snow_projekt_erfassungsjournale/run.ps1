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
