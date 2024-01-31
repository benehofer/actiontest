az login --tenant "wagner.ch"
az account set --subscription "6178e425-5861-4d3d-99e2-31bb2175fb11"
az group create --name "wid-rg-widup-001" --location "switzerlandnorth"
az deployment group what-if --resource-group "wid-rg-widup-001" --template-file ".\IaC\Deployment_WAGNERPROD\main.bicep"
$answ=Read-Host -Prompt "Continue (y/n)"
if ($answ -eq "y") {
az deployment group create --resource-group "wid-rg-widup-001" --template-file ".\IaC\Deployment_WAGNERPROD\main.bicep"
}

