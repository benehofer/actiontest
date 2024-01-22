$targetEnvironmentName=$env:appEnv

ipmo .\devops\helper.psm1 -force
$InformationPreference="Continue"

$r=Get-dplVariableDefinition -targetEnvironmentName $targetEnvironmentName | Write-dplResult
if ($r.Success) {
    $variableDefinition=$r.Value
    $r=Set-dplDirectory -variableDefinition $variableDefinition -deploymentDirectory ".\deployment\iac" | Write-dplResult
}

if (!($r.Success)) {
    throw
}
