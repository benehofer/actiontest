using namespace System.Net
param($Request, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp      

    $monitoringRecords=@()
    $monitoringRecords+=[PSCustomObject]@{
        name="queueStatus"
        description="The monitor checks the storage queues of the WIDup interface. A positive monitor result means that there are no entries in poison queues and that there are no entries in the main queues of the solution for longer than the number of minutes defined as the threshold value (parameter 'mth_max_minutes_item_in_queue')."
        statusOK = $false
        details=@()
    }
    $monitoringRecords+=[PSCustomObject]@{
        name="jobStatus"
        description="The monitor checks the regular execution of the synchronization jobs. A positive monitoring result means that all jobs that are part of a schedule are not more than the time defined as the threshold value behind the planned schedule (parameter 'mth_max_minutes_syncjob_delay')."
        statusOK = $false
        details=@()
    }
    $monitoringRecords+=[PSCustomObject]@{
        name="diffRecordStatus"
        description="The monitor checks the record diff statistics. A positive monitoring result means that difference data records recognized during the statistical check are not older than the defined threshold value (parameter 'mth_max_minutes_recorddiff_age')."
        statusOK = $false
        details=@()
    }
    $monitoringRecords+=[PSCustomObject]@{
        name="statisticStatus"
        description="The monitor checks whether the statistics functions for data differences or transmission errors in the connected systems are not executed more than the defined threshold values behind their schedule. Two parameters are relevant for this monitor, one for the statistics functions for data differences (parameter 'mth_max_minutes_statisticrun_age') and one parameter for the detection of transmission errors of timecards (parameter 'mth_max_minutes_statisticrun_tcerrors_age')."
        statusOK = $false
        details=@()
    }
    $allOk=$true
    $r=New-Result -success $true -message "bootstrap result object"
    $monitoringRecords | ? {$null -ne $_} | %{
        $mr=$_
        if ($r.Success) {
            $r=$(Invoke-Command([scriptblock]::Create("`$mr | Get-wupMon$($mr.name) | Write-Result")))
        }
        $allOk=$allOk -and $mr.statusOk
    }
    $monitoringResult=[PSCustomObject]@{
        statusOK = $allOk
        details=$monitoringRecords
    }
    if ($r.Success) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::OK
            ContentType="application/json"
            Body=$($monitoringResult | convertto-json -Depth 100 -Compress)
        })
    } else {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode=[System.Net.HttpStatusCode]::BadRequest
            ContentType="application/json"
            Body=$($r | convertto-json -Depth 100 -Compress)
        })
    }   
} catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode=[System.Net.HttpStatusCode]::InternalServerError
        ContentType="text/plain"
        Body="Unexpected error: $($_.exception.Message)"
    })        
}
