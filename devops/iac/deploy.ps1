$appEnv=$env:appEnv
$doEnv=$env:doEnv
$mode=$env:mode

Write-Host "Running iac deployment in $($mode) mode"
$r=Invoke-Command -ScriptBlock  ($([ScriptBlock]::Create("&.\$($mode).ps1")))
