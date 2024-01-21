az login --tenant "wagner.ch"
az account set --subscription "045e4288-7f9b-4c88-b100-9e837bb80e50"
az group create --name "wid-rg-widup-201" --location "switzerlandnorth"
az deployment group what-if --resource-group "wid-rg-widup-201" --template-file ".\IaC\Deployment_WAGNERTEST\main.bicep"
$answ=Read-Host -Prompt "Continue (y/n)"
if ($answ -eq "y") {
az deployment group create --resource-group "wid-rg-widup-201" --template-file ".\IaC\Deployment_WAGNERTEST\main.bicep"
}

