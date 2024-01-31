using namespace System.Net
param($Request, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    $body=[PSCustomObject]$Request.Body
    $httpHeaders=$Request.headers

    $bodyProperties=$body.psobject.Properties | select -ExpandProperty name

    $syncjob=$null
    $r=Get-wupApiSchema | Write-Result
    if ($r.Success) {
        if ($bodyProperties -contains "jobRecordType") {
            $syncJob=$global:schema.syncJobs | ? {$_.recordtype -eq $body.jobRecordType}
        }
        if ($bodyProperties -contains "jobID") {
            $syncJob=$global:schema.syncJobs | ? {$_.rowkey -eq $body.jobID}
        }
        if ($null -ne $syncjob -and (($syncjob.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -eq 'Object')) {
            $r=New-Result -success $true -message "Successfully found syncjob [$($syncJob.RowKey), $($syncJob.recordType)]" -logLevel Information | Write-Result
        } else {
            $r=New-Result -success $false -message "SnycJob not found" -logLevel Error | Write-Result
        }
    }
    if ($r.Success) {
        if ($null -eq $syncjob.queuedat) {
            $r=New-Result -success $true -message "Synjob is idle" -logLevel Information | Write-Result            
        } else {
            $r=New-Result -success $true -message "Synjob is not idle [$($syncjob.queuedat)]" -logLevel Information | Write-Result
        }
    }
    if ($r.Success) {
        if ($bodyProperties -contains "jobSyncType") {
            $syncJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value $body.jobSyncType
        } else {
            $syncJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value "delta"
        }
        if ($bodyProperties -contains "jobRunSingle") {
            $syncJob | Add-Member -MemberType NoteProperty -Name "_runSingle" -Value $body.jobRunSingle
        } else {
            $syncJob | Add-Member -MemberType NoteProperty -Name "_runSingle" -Value $true
        }
        $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:jobqueuename | Write-Result
    }
    if ($r.Success) {
        $r=Set-wupSyncJob -syncJob $syncJob -queued | Write-Result
    }
    if ($r.Success) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::OK
            ContentType="application/json"
            Body=$($syncjob | convertto-json)
        })
    } else {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::BadRequest
            ContentType="application/json"
            Body=$($r | convertto-json)
        })
    }   
} catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode=[System.Net.HttpStatusCode]::InternalServerError
        ContentType="text/plain"
        Body="Unexpected error: $($_.exception.Message)"
    })        
}
