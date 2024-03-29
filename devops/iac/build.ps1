$appEnv=$env:appEnv
$doEnv=$env:doEnv
$dpDir=$env:dpDir

ipmo .\devops\helper.psm1 -force
$InformationPreference="Continue"

$r=Get-dplVariableDefinition -targetEnvironmentName $appEnv | Write-dplResult
if ($r.Success) {
    $variableDefinition=$r.Value
    $r=Set-dplDirectoryIac -variableDefinition $variableDefinition -deploymentDirectory $dpDir | Write-dplResult
}

if (!($r.Success)) {
    throw
}
