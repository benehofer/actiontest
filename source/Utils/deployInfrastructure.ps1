param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("WIDDEV","WAGNERTEST","WAGNERPROD")]$envName,
    [switch]$autoApprove
)
Import-Module ".\Utils\Module\widuputils.psm1" -Force -WarningAction SilentlyContinue
if ($autoApprove) {Set-Environment -envName $envName -autoApprove} else {Set-Environment -envName $envName}
