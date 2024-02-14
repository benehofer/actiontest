@description('The name of the app service plan for the Azure function')
param app_service_plan_name string = 'plan-hofb-wup-tst-sn-01'

@description('The name of the the application insights resource')
param application_insigths_name string = 'appi-hofb-wup-tst-sn-01'

@description('The id of the service principal for accessing the bc environment')
param bc_sp_clientid string = 'fb69fb7c-6a0c-41bf-b3d0-2d56fef22081'

@description('The name of the bc service principal secret in key vault')
param bc_sp_kvsecretname string = 'bcsecret'

@description('The bc api url for the debitor (customers) entity')
param bc_url_debitor string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/customer/v1.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/customers'

@description('The bc api url for the employe entity')
param bc_url_employee string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/employees'

@description('The bc api url for the jobheads entity')
param bc_url_jobhead string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobsHeaders'

@description('The bc api url for the jobledger entity')
param bc_url_jobledger string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobLedgerEntries'

@description('The bc api url for the jobplanninglines entity')
param bc_url_jobplanningline string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobPlanningLines'

@description('The bc api url for the jobtasks entity')
param bc_url_jobtask string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobTasks'

@description('The bc api url for the journal entity')
param bc_url_journal string = 'https://api.businesscentral.dynamics.com/v2.0/TEST/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobWorksheets'

@description('The url of the CRM environment')
param crm_environment_url string = 'https://org818ba903.crm17.dynamics.com'

@description('The dataverse environment id')
param dv_environment_id string = 'Default-f6819965-9fb4-4295-b341-4d250431078c'

@description('The dataverse publisher prefix')
param dv_environment_publisherprefix string = 'widup'

@description('The dataverse solution name')
param dv_environment_solutionname string = 'widup'

@description('The url of the Dataverse environment')
param dv_environment_url string = 'https://org159ce083.crm17.dynamics.com'

@description('The dv api url for the debitor entity (the environment url will pe prefixed to this)')
param dv_url_debitor string = '/api/data/v9.2/widup_debitors'

@description('The dv api url for the jobheads entity (the environment url will pe prefixed to this)')
param dv_url_jobhead string = '/api/data/v9.2/widup_jobheads'

@description('The dv api url for the jobplanninglines entity (the environment url will pe prefixed to this)')
param dv_url_jobplanningline string = '/api/data/v9.2/widup_jobplanninglines'

@description('The dv api url for the jobtasks entity (the environment url will pe prefixed to this)')
param dv_url_jobtask string = '/api/data/v9.2/widup_jobtasks'

@description('The dv api url for the journal entity (the environment url will pe prefixed to this)')
param dv_url_journal string = '/api/data/v9.2/widup_journals'

@description('The name of the Azure function app')
param function_app_name string = 'func-hofb-wup-tst-sn-01'

@description('The resource id of the subnet for the function app integration')
param function_app_vnet_integration_subnet_id string = '/subscriptions/281a469b-3f25-4913-9644-efb65d48a83f/resourceGroups/rg-hofb-net-shd-sn-01/providers/Microsoft.Network/virtualNetworks/vnet-hofb-net-shd-sn-01/subnets/snet-with-webserverfarm-delegation'

@description('The name of the hybrid connection')
param hybrid_connection_name string = 'hycon-hofb-wup-tst-sn-01'

@description('The fqdn of the ad server name used in the hybrid connection')
param hycon_adserver_name string = 'adserver.testad.local'

@description('The port of the ad server used in the hybrid connection')
param hycon_adserver_port int = 5986

@description('The name of the Azure keyvault')
param keyvault_name string = 'vault-hofb-wup-tst-sn-01'

@description('The id of the vault administrator role')
param keyvaultadministrator_role_id string = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

@description('The id of the vault secrets officer role')
param keyvaultsecretsofficer_role_id string = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

@description('The id of the vault secrets user role')
param keyvaultsecretsuser_role_id string = '4633458b-17de-408a-b874-0445c86b69e6'

@description('Location for resources of the deployment')
param location string = 'switzerlandnorth'

@description('The name of the log analytics workspace used by application inights resource the Azure function')
param log_analytics_workspace_name string = 'log-hofb-wup-tst-sn-01'

@description('The name of the managed identity of the Azure function')
param managed_identity_name string = 'id-hofb-wup-tst-sn-01'

@description('The name of the relay namespace for the hybrid connection')
param relay_namespace_name string = 'rns-hofb-wup-tst-sn-01'

@description('The name of the resource group for the resources of the deployment')
param resource_group_name string = 'rg-hofb-wup-tst-sn-01'

@description('The SKU family name for the app service plan')
param service_plan_sku_family string = 'EP'

@description('The SKU name for the app service plan')
param service_plan_sku_name string = 'EP1'

@description('The tier name for the app service plan')
param service_plan_sku_tier string = 'ElasticPremium'

@description('The name of the basic token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_token_kvsecretname string = 'snowtoken'

@description('The snow api url for the debitor entity')
param snow_url_debitor string = 'https://wagnerdev.service-now.com/api/now/import/u_import_msbc_debitor'

@description('The snow api url for the jobheads entity')
param snow_url_jobhead string = 'https://wagnerdev.service-now.com/api/now/import/u_import_msbc_projektkopf'

@description('The snow api url for the jobplanninglines entity')
param snow_url_jobplanningline string = 'https://wagnerdev.service-now.com/api/now/import/u_import_msbc_projektplanzeile'

@description('The snow api url for the jobtasks entity')
param snow_url_jobtask string = 'https://wagnerdev.service-now.com/api/now/import/u_import_msbc_projektaufgabe'

@description('The name of the ad queue')
param storage_account_ad_queue_name string = 'adqueue'

@description('The name of the schema table')
param storage_account_apischema_table_name string = 'apischema'

@description('The name of the bc queue')
param storage_account_bc_queue_name string = 'bcqueue'

@description('The name of the cache blob container')
param storage_account_cache_container_name string = 'cacheblob'

@description('The name of the dv queue')
param storage_account_dv_queue_name string = 'dvqueue'

@description('The name of the job queue')
param storage_account_job_queue_name string = 'jobqueue'

@description('The name of the storage account')
param storage_account_name string = 'sahofbwuptstsn01'

@description('The name of the SKU for the storage account')
param storage_account_sku_name string = 'Standard_LRS'

@description('The name of the snow queue')
param storage_account_snow_queue_name string = 'snowqueue'

@description('The name of the syncjob table')
param storage_account_syncjob_table_name string = 'syncjob'

@description('The id of the storage blob data contributor role')
param storageblobdatacontributor_role_id string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

@description('The id of the storage queue data contributror role')
param storagequeuedatacontributor_role_id string = '974c5e8b-45b9-4653-ba55-5f855dd0fb88'

@description('The id of the storage table data contributror role')
param storagetabledatacontributor_role_id string = '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'

@description('Target subscription id')
param target_subscription_id string = '281a469b-3f25-4913-9644-efb65d48a83f'

@description('Target tenant id')
param tenant_id string = 'f6819965-9fb4-4295-b341-4d250431078c'

@description('Target tenant name')
param tenant_name string = 'wid.dev'

@description('The name of the Azure static web app')
param static_web_app_name string = 'stapp-hofb-wup-tst-sn-01'

@description('The name of the managed identity for the Azure static web app')
param swa_managed_identity_name string = 'id-hofb-wup-tst-sn-02'

@description('The name of the managed identity for the bicep deployment script')
param bicep_managed_identity_name string = 'id-hofb-bicep-tst-sn-03'

@description('The name of the managed identity for the bicep deployment script')
param swa_registered_app_name string = 'appReg-hofb-wup-tst-sn-01'

@description('The name of the keyvault secret for SWA registered application client id')
param swa_registered_app_client_id_kvsecretname string = 'SWA-APP-CLIENT-ID'

@description('The name of the keyvault secret for SWA registered application client secret')
param swa_registered_app_client_secret_kvsecretname string = 'SWA-APP-CLIENT-SECRET'



param currentTime string = utcNow()

resource scriptAppReg 'Microsoft.Resources/deploymentScripts@2023-08-01'={
  name: 'RegisterAppForSWA'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId(resource_group_name, 'Microsoft.ManagedIdentity/userAssignedIdentities', bicep_managed_identity_name)}': {}
    }
  }
  properties: {
    azPowerShellVersion: '5.0'
    arguments: '-resourceName "${swa_registered_app_name}"'
    scriptContent: '''
      param([string] $resourceName)
      $token = (Get-AzAccessToken -ResourceUrl https://graph.microsoft.com).Token
      $headers = @{'Content-Type' = 'application/json'; 'Authorization' = 'Bearer ' + $token}

      $appRegTmpl = @{
        displayName = $resourceName
        requiredResourceAccess = @(
          @{
            resourceAppId = "00000003-0000-0000-c000-000000000000"
            resourceAccess = @(
              @{
                id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
                type = "Scope"
              }
            )
          }
        )
        signInAudience = "AzureADMyOrg"
      }
      
      # Upsert App registration
      $app = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/beta/applications?filter=displayName eq '$($resourceName)'").value
      $principal = @{}
      if ($app) {
        $ignore = Invoke-RestMethod -Method Patch -Headers $headers -Uri "https://graph.microsoft.com/beta/applications/$($app.id)" -Body ($appRegTmpl | ConvertTo-Json -Depth 10)
        $principal = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=appId eq '$($app.appId)'").value
      } else {
        $app = (Invoke-RestMethod -Method Post -Headers $headers -Uri "https://graph.microsoft.com/beta/applications" -Body ($appRegTmpl | ConvertTo-Json -Depth 10))
        $principal = Invoke-RestMethod -Method POST -Headers $headers -Uri  "https://graph.microsoft.com/beta/servicePrincipals" -Body (@{ "appId" = $app.appId } | ConvertTo-Json)
      }
      
      # Creating client secret
      $app = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/beta/applications/$($app.id)")
      
      foreach ($password in $app.passwordCredentials) {
        Write-Host "Deleting secret with id: $($password.keyId)"
        $body = @{
          "keyId" = $password.keyId
        }
        $ignore = Invoke-RestMethod -Method POST -Headers $headers -Uri "https://graph.microsoft.com/beta/applications/$($app.id)/removePassword" -Body ($body | ConvertTo-Json)
      }
      
      $body = @{
        "passwordCredential" = @{
          "displayName"= "Client Secret"
        }
      }
      $secret = (Invoke-RestMethod -Method POST -Headers $headers -Uri  "https://graph.microsoft.com/beta/applications/$($app.id)/addPassword" -Body ($body | ConvertTo-Json)).secretText
      
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['objectId'] = $app.id
      $DeploymentScriptOutputs['clientId'] = $app.appId
      $DeploymentScriptOutputs['clientSecret'] = $secret
      $DeploymentScriptOutputs['principalId'] = $principal.id

    '''
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    forceUpdateTag: currentTime // ensures script will run every time
  }
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvault_name
  location: location
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    tenantId: tenant_id
    enableRbacAuthorization: true
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource kvs_clientID 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_id_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientId
      //value: 'test123'
  }
}

resource kvs_clientSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_secret_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientSecret
      //value: 'test123'
  }
}

resource mi_swa 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: swa_managed_identity_name
  location: location
}

resource mi_swa_keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, mi_swa.id, keyvaultsecretsuser_role_id)
  scope: kv
  properties: {
    principalId: mi_swa.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',keyvaultsecretsuser_role_id)
    principalType: 'ServicePrincipal'
  }
}

resource swa 'Microsoft.Web/staticSites@2022-09-01' = {
  name: static_web_app_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'None'
    enterpriseGradeCdnStatus: 'Disabled'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mi_swa.id}': {}
    }    
  }
  resource config 'config@2022-09-01' = {
    name: 'appsettings'
    kind: 'string'
    properties: {
      APP_CLIENT_ID: '@Microsoft.KeyVault(SecretUri=${kvs_clientID.properties.secretUri})'
      APP_CLIENT_SECRET: '@Microsoft.KeyVault(SecretUri=${kvs_clientSecret.properties.secretUri})'
    }
  }
}





