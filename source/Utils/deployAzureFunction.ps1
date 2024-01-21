param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("WIDDEV","WAGNERTEST","WAGNERPROD")]$envName,
    [switch]$deployKeys
)
$solutionBasePath="Azure Functions"
Import-Module ".\Utils\Module\widuputils.psm1" -Force -WarningAction SilentlyContinue
Deploy-AzureFunction -envName $envName -solutionBasePath $solutionBasePath
if ($deployKeys) {
    Deploy-FunctionKeys -envName $envName -solutionBasePath $solutionBasePath
}
