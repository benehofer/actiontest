<#
<DOC>
In contrast to the other queue workers, the syncjob queue worker is not responsible for 
transferring data to one of the peripheral systems connected to WIDup, but is used to 
process the jobs in the WIDup interface. The synjob queue worker has two modes, a start 
and an end mode.<br/>All schedule-based jobs of the interface start their cycle via the 
queues in the syncjob queue and are processed first by the associated worker <section:widup queues>. 
In start mode, the synjob queue worker loads the data from the source system and adds the 
sourceData data set to the syncjob data set before forwarding the data set to the target 
queue.<br/>All jobs, both schedule-based and trigger-based jobs, end their cycle via the 
queues in the syncjob queue. The worker recognises that it is a job that has completed its 
cycle; as a criterion, it checks whether the syncjob data record (already) contains a _started 
attribute. If this is the case, the current job is completed. To do this, the execution of 
the job is first noted in the syncjobs table. it is then checked whether a "next job" is 
defined for the current job in the configuration; if this is the case, this next job is 
started by inserting a corresponding syncjob data record into the job queue. If not, or if 
the current job was started in single mode (_runSingle), no next job is started.<br/>
Finally - if everything was successful up to that point - the current blob is deleted in both 
start and end mode <section:queue worker processing>.
</DOC>
#>
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
