# Input bindings are passed in via param block.
param([object]$QueueItem, $TriggerMetadata)
try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    #$syncJob=$QueueItem | convertto-json -depth 100 | convertfrom-json -depth 100
    $queueEntry=$QueueItem | convertto-json -depth 100 | convertfrom-json -depth 100
    $queueEntry
    $r=Get-wupQueueMessage -queueEntry $queueEntry | Write-Result

    if ($r.Success) {
        $syncJob=$r.Value
        $r=Get-wupApiSchema | Write-Result
    }
    if ($r.Success) {
        $mode=$(if ($null -eq $syncJob._started) {"start"} else {"end"})
    }
    switch ($mode) {
        "start" {
            if ($r.Success) {
                $sourceUrl=$(Invoke-Command([scriptblock]::Create("`$global:$($syncJob.sourceType)url$($syncJob.recordType)")))
                $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceUrl" -Value $sourceUrl
                $r=Get-wupData -syncJob $syncJob | Write-Result
            }
            if ($r.Success) {
                $sourceData=$r.Value
                if ($null -eq $sourceData) {$sourceData=@()}
                if ($syncJob.recordtype -eq 'employee') {
                    $r=Set-wupEmployeeData -sourceData $sourceData | Write-Result
                }
            }
            if ($r.success) {
                $syncJob | Add-Member -MemberType NoteProperty -Name "_started" -Value (get-date).ToString("s")
                $syncJob | Add-Member -MemberType NoteProperty -Name "_sourceData" -Value $sourceData
                $queueName=$(Invoke-Command([scriptblock]::Create("`$global:$($syncjob.destinationType)queuename")))
                $r=Add-wupQueueMessage -queueMessage $syncJob -queueName $queuename | Write-Result
            }
            if ($r.Success) {
                $r=New-Result -success $true -message "Successfully retrieved $($sourceData.length) source records of type $($syncJob.recordType)" | Write-Result
            }
            break
        }
        "end" {
            if ($r.Success) {
                $r=Set-wupSyncJob -syncJob $syncJob -finished | Write-Result
            }
            if ($r.Success) {
                if (($null -ne $syncJob.nextJob) -and ($syncJob.nextJob -ne "") -and (!($syncJob._runSingle -eq $true))) {
                    $nextJob=$global:schema.syncJobs | ? {$_.rowKey -eq $syncJob.nextJob}
                    if ($null -ne $nextJob) {
                        if ($null -eq $nextJob.queuedat) {
                            $nextJob | Add-Member -MemberType NoteProperty -Name "_syncType" -Value $syncJob._syncType
                            $nextJob | Add-Member -MemberType NoteProperty -Name "_previousJob" -Value $syncJob
                            $r=Add-wupQueueMessage -queueMessage $nextJob -queueName $global:jobqueuename | Write-Result
                            if ($r.Success) {
                                $r=Set-wupSyncJob -syncJob $nextJob -queued | Write-Result
                            }                        
                        } else {
                            $r=New-Result -success $true -message "Next job still/already queued: [$($nextJob.queuedat)]" -logLevel Error | Write-Result
                        }
                    } else {
                        $r=New-Result -success $true -message "Next job not found: [$($syncJob.nextJob)]" -logLevel Error | Write-Result
                    }
                } else {
                    if ($syncJob._runSingle) {
                        $r=New-Result -success $true -message "Job was started in single run mode; queueing nextjob is suppressed [$($syncJob.RowKey)]" | Write-Result
                    } else {
                        $r=New-Result -success $true -message "Job does not have nextjob to trigger [$($syncJob.RowKey)]" | Write-Result
                    }
                }
            }
            break
        }
    }

    if ($r.Success) {
        $r=Remove-wupQueueMessage -queueEntry $queueEntry | Write-Result
    }
    if ($r.Success) {            
        $r=New-Result -success $true -message "Successfully executed SYNCJOB queueworker in '$($mode)' mode [$($syncJob.RowKey)]" -value $sourceData -logLevel Information
    }        
} catch {
    $r=New-Result -success $false -message "Error processing SYNCJOB queueworker in '$($mode)' mode" -exception $_.exception -logLevel Error
}
$r | Write-Result -NoPassThru
if ($r.Success) {
    
} else {
    throw $($r.message)
}
