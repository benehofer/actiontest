az group create --name "" --location ""
az deployment group what-if --resource-group "" --template-file ".\deployment\iac\main.bicep"
az deployment group create --resource-group "" --template-file ".\deployment\iac\main.bicep"

