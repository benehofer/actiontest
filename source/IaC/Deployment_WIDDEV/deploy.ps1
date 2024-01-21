az login --tenant "wid.dev"
az account set --subscription "281a469b-3f25-4913-9644-efb65d48a83f"
az group create --name "rg-hofb-wup-tst-sn-01" --location "switzerlandnorth"
az deployment group create --resource-group "rg-hofb-wup-tst-sn-01" --template-file ".\IaC\Deployment_WIDDEV\main.bicep"

