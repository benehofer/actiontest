az login --tenant "wid.dev"
az account set --subscription "281a469b-3f25-4913-9644-efb65d48a83f"
$rg=$(az group create --name "rg-hofb-swa-tst-sn-01" --location "switzerlandnorth")
$mi=$((az identity create -g "rg-hofb-swa-tst-sn-01" -n "id-hofb-bicep-tst-sn-03") | convertfrom-json)
$role=$((az rest --headers Content-Type=application/json --method POST --uri 'https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments' --body $('{\"principalId\": \"' + $($mi.principalId) + '\", \"roleDefinitionId\": \"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3\", \"directoryScopeId\": \"/\"}')) | convertfrom-json)
az deployment group what-if --resource-group "rg-hofb-swa-tst-sn-01" --template-file ".\Snippets\bicep\swa.bicep"
$answ=Read-Host -Prompt "Continue (y/n)"
if ($answ -eq "y") {
    az deployment group create --resource-group "rg-hofb-swa-tst-sn-01" --template-file ".\Snippets\bicep\swa.bicep"
}

