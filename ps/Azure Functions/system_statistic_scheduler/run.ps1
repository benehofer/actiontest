param($Timer)

Import-Module widtools -WarningAction SilentlyContinue
Import-Module widup -WarningAction SilentlyContinue
Initialize-WIDUp

$r=set-wupStatistics -dayOffset 0 | Write-Result

if ($r.Success) {
    
} else {
    throw $($r.message)
}
