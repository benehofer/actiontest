param($Timer)

Import-Module widtools -WarningAction SilentlyContinue
Import-Module widup -WarningAction SilentlyContinue
Initialize-WIDUp

#$r=set-wupStatistics -dayOffset 0 | Write-Result
$r=Get-wupStatRun -statisticsType jobTask | Write-Result
if ($r.success) {    
    $statisticrun=$r.value
    $r=$statisticRun | Invoke-wupStatistic
    $r | Write-Result -NoPassThru
}
if ($r.success) {
    $r=Get-wupStatRun -statisticsType jobPlanningLine | Write-Result
}
if ($r.success) {    
    $statisticrun=$r.value    
    $r=$statisticRun | Invoke-wupStatistic
    $r | Write-Result -NoPassThru
}
if ($r.success) {
    $r=Get-wupStatRun -statisticsType journal | Write-Result
}
if ($r.success) {    
    $statisticrun=$r.value
    $r=$statisticRun | Invoke-wupStatistic
    $r | Write-Result -NoPassThru
}
if ($r.success) {
    $r=Set-wupStatRecordDiffs | Write-Result
}

if ($r.Success) {
    
} else {
    throw $($r.message)
}
