$envName="WAGNERTEST"

$variableDefFile=".\variables.json"
Import-Module ".\Utils\Module\widuputils.psm1" -Force -WarningAction SilentlyContinue
Import-Module ".\Utils\Module\dvSchemaTools.psm1" -Force -WarningAction SilentlyContinue
Get-ConfigForLocalDebug -envName $envName
Import-Module '.\Azure Functions\Modules\widup\widup.psm1' -WarningAction SilentlyContinue -Force
Import-Module '.\Azure Functions\Modules\widtools\widtools.psm1' -WarningAction SilentlyContinue -Force
Initialize-WIDUp
$v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
az login --tenant $v.variables.tenant_name.value
az account set --subscription $v.variables.target_subscription_id.value
$InformationPreference="Continue"

$functionKeys=Get-FunctionKeys
Backup-VaultSecrets -envName $envName
Deploy-DVSchema -envName $envName -schemaDefinitionFile ".\Snippets\schema_dv2.xlsx"

###add bcsecret vault secret
###add snow secret vault secret

