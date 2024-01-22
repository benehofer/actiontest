$targetEnvironmentName=$env:appEnv

ipmo .\devops\helper.psm1


$r=Get-dplVariableDefinition -targetEnvironmentName $targetEnvironmentName | Write-dplResult

new-item .\deployment\iac -ItemType Directory
"Test" | out-file .\deployment\iac\artifact_iac.txt
