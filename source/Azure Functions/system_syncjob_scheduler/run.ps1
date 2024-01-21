param($Timer)

Import-Module widtools -WarningAction SilentlyContinue
Import-Module widup -WarningAction SilentlyContinue
Initialize-WIDUp

$r=Get-wupApiSchema | Write-Result
if ($r.Success) {
    $jobsStarted=0
    $global:schema.syncJobs | ? {($_.frequencyDeltaSync -gt 0 -or $_.frequencyFullSync -gt 0) -and ($_.queuedAt -eq "" -or $_.queuedAt -eq $null)} | ? {$null -ne $_} | %{
        $syncJob=$_
        $nextRun=""
        if ($syncJob.frequencyFullSync -ne "") {
            if ($syncJob.lastFullSyncAt -eq $null) {
                $nextRun="full"
            } else {
                if ((New-TimeSpan -Start $($syncJob.lastFullSyncAt) -End (get-date)).TotalMinutes -gt $syncJob.frequencyFullSync) {
                    $nextRun="full"
                }
            }
        }
        if ($nextRun -eq "") {
            if ($syncJob.frequencyDeltaSync -ne "") {
                if ($syncJob.lastDeltaSyncAt -eq $null) {
                    $nextRun="delta"
                } else {
                    if ((New-TimeSpan -Start $($syncJob.lastDeltaSyncAt) -End (get-date)).TotalMinutes -gt $syncJob.frequencyDeltaSync) {
                        $nextRun="delta"
                    }    
                }
            }
        }
        if ($nextRun -ne "") {
            $syncJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value $nextRun
            $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $global:jobqueuename | Write-Result
            if ($r.Success) {
                $r=Set-wupSyncJob -syncJob $syncJob -queued | Write-Result
                $jobsStarted+=1
            }
        }
    }
    if ($jobsStarted -gt 0 -and $r.Success) {
        $r=New-Result -success $true -message "Successfully added $($jobsStarted) jobs to queue" | Write-Result
    }
    if ($jobsStarted -eq 0 -and $r.Success) {
        $r=New-Result -success $true -message "Currently no jobs are pending execution" | Write-Result
    }
}
if ($r.Success) {
    
} else {
    throw $($r.message)
}
