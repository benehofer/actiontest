param($Timer)

Import-Module widtools -WarningAction SilentlyContinue
Import-Module widup -WarningAction SilentlyContinue
Initialize-WIDUp

$r=Get-wupStatRun -statisticsType timeCardErrors | Write-Result
if ($r.success) {    
    $statisticRun=$r.value
    $r=$statisticRun | Invoke-wupStatTimecardErrors | Write-Result
}

if ($r.Success) {
    
} else {
    throw $($r.message)
}
