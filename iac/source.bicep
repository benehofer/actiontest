param currentTime string = utcNow()

//Storage Account
resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storage_account_name
  location: location
  sku: {
    name: storage_account_sku_name
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion:'TLS1_2'
  }
}

resource sa_queueService 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  name: 'default'
  parent: sa
}

resource sa_queue1 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_job_queue_name
  parent: sa_queueService
}

resource sa_queue2 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_snow_queue_name
  parent: sa_queueService
}

resource sa_queue3 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_dv_queue_name
  parent: sa_queueService
}

resource sa_queue4 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_bc_queue_name
  parent: sa_queueService
}

resource sa_queue5 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_ad_queue_name
  parent: sa_queueService
}

resource sa_tableService 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
  name: 'default'
  parent: sa
}

resource sa_table1 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_apischema_table_name
  parent: sa_tableService
}

resource sa_table2 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_syncjob_table_name
  parent: sa_tableService
}

resource sa_table3 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_department_table_name
  parent: sa_tableService
}

resource sa_table4 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_location_table_name
  parent: sa_tableService
}

resource sa_blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: sa
}

resource sa_container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: storage_account_cache_container_name
  parent: sa_blobService
  properties: {
    publicAccess:'None'
    metadata: {}
  }
}

//Log analytics workspace and ai
resource aiWS 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: log_analytics_workspace_name
  location: location
}
resource ai 'Microsoft.Insights/components@2020-02-02' = {
  name: application_insigths_name
  location: location
  kind: 'other'
  properties: {
    Application_Type: 'other'
    WorkspaceResourceId: aiWS.id
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
  }
}

//Managed identity and role assignements
resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managed_identity_name
  location: location
}
resource mi_storageTableDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storagetabledatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storagetabledatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
resource mi_role_storageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storageblobdatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storageblobdatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
resource mi_storageQueueDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storagequeuedatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storagequeuedatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
resource mi_keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, mi.id, keyvaultsecretsuser_role_id)
  scope: kv
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',keyvaultsecretsuser_role_id)
    principalType: 'ServicePrincipal'
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


//App Plan
resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: app_service_plan_name
  location: location
  kind: 'functionapp'
  sku: {
    name: service_plan_sku_name
    tier: service_plan_sku_tier
    size: service_plan_sku_name
    family: service_plan_sku_family
  }
  properties: {
    maximumElasticWorkerCount:1
  }
}

//Function App
resource app 'Microsoft.Web/sites@2022-03-01' = {
  name: function_app_name
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: asp.id
    siteConfig: {
      minTlsVersion: '1.2'
      localMySqlEnabled: false
      netFrameworkVersion: 'v4.6'
      cors: {
        allowedOrigins:[
          'https://portal.azure.com'
        ]
      }
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sa.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sa.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sa.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sa.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(function_app_name)
        }     
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }   
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: ai.properties.InstrumentationKey
        }
        {
          name: 'MSI_CLIENT_ID'
          value: mi.properties.clientId
        }
        {
          name: 'MANAGED_IDENTITY_NAME'
          value: mi.name
        }
        {
          name: 'TENANT_ID'
          value: tenant_id
        }
        {
          name: 'API_BASE_URL'
          value: api_base_url
        }
        {
          name: 'VAULT_AUTHENTICATION_URI'
          value: 'https://vault.azure.net'
        }
        {
          name: 'VAULT_URI'
          value: kv.properties.vaultUri
        }
        {
          name: 'BC_SP_CLIENTID'
          value: bc_sp_clientid
        }
        {
          name: 'BC_SP_KVSECRETNAME'
          value: bc_sp_kvsecretname
        }
        {
          name: 'BC_URL_JOBHEAD'
          value: bc_url_jobhead
        }
        {
          name: 'BC_URL_JOBTASK'
          value: bc_url_jobtask
        }
        {
          name: 'BC_URL_JOBPLANNINGLINE'
          value: bc_url_jobplanningline
        }
        {
          name: 'BC_URL_DEBITOR'
          value: bc_url_debitor
        }
        {
          name: 'BC_URL_JOURNAL'
          value: bc_url_journal
        }
        {
          name: 'BC_URL_JOBWORKSHEET'
          value: bc_url_jobworksheet
        }
        {
          name: 'BC_URL_EMPLOYEE'
          value: bc_url_employee
        }
        {
          name: 'BC_URL_JOBLEDGER'
          value: bc_url_jobledger
        }
        {
          name: 'BC_URL_EMPLOYEEDIMENSIONS'
          value: bc_url_employeedimensions
        }
        {
          name: 'BC_URL_DEPARTMENTSUPERVISORS'
          value: bc_url_departmentsupervisors
        }
        {
          name: 'BC_URL_DEPARTMENTS'
          value: bc_url_departments
        }
        {
          name: 'CRM_ENVIRONMENT_URL'
          value: crm_environment_url
        }
        {
          name: 'DV_ENVIRONMENT_URL'
          value: dv_environment_url
        }
        {
          name: 'DV_ENVIRONMENT_PUBLISHERPREFIX'
          value: dv_environment_publisherprefix
        }       
        {
          name: 'QUEUE_STORAGE_URI'
          value: sa.properties.primaryEndpoints.queue
        }
        {
          name: 'JOB_QUEUE_NAME'
          value: storage_account_job_queue_name
        }
        {
          name: 'SNOW_QUEUE_NAME'
          value: storage_account_snow_queue_name
        }
        {
          name: 'DV_QUEUE_NAME'
          value: storage_account_dv_queue_name
        }
        {
          name: 'BC_QUEUE_NAME'
          value: storage_account_bc_queue_name
        }
        {
          name: 'BC_QUEUE_BATCH_SIZE'
          value: bc_queuebatchsize
        }       
        {
          name: 'AD_QUEUE_NAME'
          value: storage_account_ad_queue_name
        }
        {
          name: 'APISCHEMA_TABLE_NAME'
          value: storage_account_apischema_table_name
        }
        {
          name: 'DEPARTMENT_TABLE_NAME'
          value: storage_account_department_table_name
        }
        {
          name: 'LOCATION_TABLE_NAME'
          value: storage_account_location_table_name
        }        
        {
          name: 'SYNCJOB_TABLE_NAME'
          value: storage_account_syncjob_table_name
        }        
        {
          name: 'TABLE_STORAGE_URI'
          value: sa.properties.primaryEndpoints.table
        }
        {
          name: 'SNOW_TOKEN_KVSECRETNAME'
          value: snow_token_kvsecretname
        }
        {
          name: 'SNOW_ADMIN_TOKEN_KVSECRETNAME'
          value: snow_admin_token_kvsecretname
        }
        {
          name: 'SNOW_ADMIN2_TOKEN_KVSECRETNAME'
          value: snow_admin2_token_kvsecretname
        }
        {
          name: 'SNOW_URL_JOBHEAD'
          value: snow_url_jobhead
        }
        {
          name: 'SNOW_URL_JOBTASK'
          value: snow_url_jobtask
        }
        {
          name: 'SNOW_URL_JOBPLANNINGLINE'
          value: snow_url_jobplanningline
        }
        {
          name: 'SNOW_URL_DEBITOR'
          value: snow_url_debitor
        }
        {
          name: 'SNOW_TABLE_URL_DEBITOR'
          value: snow_table_url_debitor
        }
        {
          name: 'SNOW_TABLE_URL_JOBHEAD'
          value: snow_table_url_jobhead
        }
        {
          name: 'SNOW_TABLE_URL_JOBTASK'
          value: snow_table_url_jobtask
        }
        {
          name: 'SNOW_TABLE_URL_JOBPLANNINGLINE'
          value: snow_table_url_jobplanningline
        }
        {
          name: 'SNOW_TABLE_URL_JOURNAL'
          value: snow_table_url_journal
        }
        {
          name: 'SNOW_TABLE_URL_OUTBOUND_MESSAGE'
          value: snow_table_url_outbound_message
        }
        {
          name: 'DV_URL_JOBHEAD'
          value: '${dv_environment_url}${dv_url_jobhead}'
        }
        {
          name: 'DV_URL_JOBTASK'
          value: '${dv_environment_url}${dv_url_jobtask}'
        }
        {
          name: 'DV_URL_JOBPLANNINGLINE'
          value: '${dv_environment_url}${dv_url_jobplanningline}'
        }
        {
          name: 'DV_URL_DEBITOR'
          value: '${dv_environment_url}${dv_url_debitor}'
        }
        {
          name: 'DV_URL_JOURNAL'
          value: '${dv_environment_url}${dv_url_journal}'
        }
        {
          name: 'DV_URL_EMPLOYEE'
          value: '${dv_environment_url}${dv_url_employee}'
        }
        {
          name: 'DV_URL_STATISTIC'
          value: '${dv_environment_url}${dv_url_statistic}'
        }        
        {
          name: 'DV_URL_STATISTICRUN'
          value: '${dv_environment_url}${dv_url_statisticrun}'
        }
        {
          name: 'DV_URL_RECORDDIFF'
          value: '${dv_environment_url}${dv_url_recorddiff}'
        }
        {
          name: 'BLOB_STORAGE_URI'
          value: sa.properties.primaryEndpoints.blob
        }
        {
          name: 'CACHE_CONTAINER_NAME'
          value: storage_account_cache_container_name
        }
        {
          name: 'AD_SERVER_NAME'
          value: hycon_adserver_name
        }
        {
          name: 'AD_SERVER_PORT'
          value: hycon_adserver_port
        }      
        {
          name: 'AD_USERNAME_KVSECRETNAME'
          value: ad_username_kvsecretname
        }
        {
          name: 'AD_USERPASSWORD_KVSECRETNAME'
          value: ad_userpassword_kvsecretname
        }
        {
          name: 'AD_USEROU_PATH'
          value: ad_useroupath
        }
        {
          name: 'AD_GROUPOU_PATH'
          value: ad_groupoupath
        }
        {
          name: 'AD_ASSIGNMENTGROUP_PREFIX'
          value: ad_assignmentgroup_prefix
        }
        {
          name: 'MTH_MAX_MINUTES_ITEM_IN_QUEUE'
          value: mth_max_minutes_item_in_queue
        }
        {
          name: 'MTH_MAX_MINUTES_SYNCJOB_DELAY'
          value: mth_max_minutes_syncjob_delay
        }
        {
          name: 'MTH_MAX_MINUTES_RECORDDIFF_AGE'
          value: mth_max_minutes_recorddiff_age
        }
        {
          name: 'MTH_MAX_MINUTES_STATISTICRUN_AGE'
          value: mth_max_minutes_statisticrun_age
        }
        {
          name: 'MTH_MAX_MINUTES_STATISTICRUN_TCERRORS_AGE'
          value: mth_max_minutes_statisticrun_tcerrors_age
        }
      ]
    }
    httpsOnly: true
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mi.id}': {}
    }
  }
}

resource networkConfig 'Microsoft.Web/sites/networkConfig@2022-03-01' = if (!empty(function_app_vnet_integration_subnet_id)) {
  parent: app
  name: 'virtualNetwork'
  properties: {
    //subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', function_app_vnet_name, function_app_snet_name)
    subnetResourceId: function_app_vnet_integration_subnet_id
    swiftSupported: true
  }
}

resource rns 'Microsoft.Relay/namespaces@2021-11-01' = {
  name: relay_namespace_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
  }
}

resource rnsrule 'Microsoft.Relay/namespaces/authorizationrules@2021-11-01' = {
  parent: rns
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource hycon 'Microsoft.Relay/namespaces/hybridconnections@2021-11-01' = {
  parent: rns
  name: hybrid_connection_name
  properties: {
    requiresClientAuthorization: true
    userMetadata: '[{"key":"endpoint","value":"${hycon_adserver_name}:${hycon_adserver_port}"}]'
  }
}

resource rnsnrs 'Microsoft.Relay/namespaces/networkRuleSets@2021-11-01' = {
  parent: rns
  name: 'default'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    ipRules: []
  }
}

resource hycconrule_listener 'Microsoft.Relay/namespaces/hybridconnections/authorizationrules@2021-11-01' = {
  parent: hycon
  name: 'defaultListener'
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource hyconrule_sender 'Microsoft.Relay/namespaces/hybridconnections/authorizationrules@2021-11-01' = {
  parent: hycon
  name: 'defaultSender'
  properties: {
    rights: [
      'Send'
    ]
  }
}

resource app_hycon 'Microsoft.Web/sites/hybridConnectionNamespaces/relays@2022-03-01' = {
  name: '${app.name}/${rns.name}/${hycon.name}'
  properties: {
    serviceBusNamespace: rns.name
    relayName: hycon.name
    relayArmUri: '${rns.id}/hybridConnections/${hycon.name}'
    hostname: hycon_adserver_name
    port: hycon_adserver_port
    sendKeyName: 'defaultSender'
    sendKeyValue: listKeys('${rns.id}/hybridConnections/${hycon.name}/authorizationRules/defaultSender', '2021-11-01').primaryKey
    serviceBusSuffix: '.servicebus.windows.net'
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
resource kvs_adusername 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: ad_username_kvsecretname
  properties: {
    value: ad_username
  }
}
resource kvs_aduserpassword 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: ad_userpassword_kvsecretname
  properties: {
    value: ad_userpassword
  }
}
resource kvs_clientID 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_id_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientId
  }
}
resource kvs_clientSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_secret_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientSecret
  }
}

//Script deployment resource for registered application/service principal for swa
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
      $app = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/v1.0/applications?`$filter=displayName eq '$($resourceName)'").value
      $principal = @{}
      if ($app) {
        $ignore = Invoke-RestMethod -Method Patch -Headers $headers -Uri "https://graph.microsoft.com/v1.0/applications/$($app.id)" -Body ($appRegTmpl | ConvertTo-Json -Depth 10)
        $principal = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/v1.0/servicePrincipals?`$filter=appId eq '$($app.appId)'").value
      } else {
        $app = (Invoke-RestMethod -Method Post -Headers $headers -Uri "https://graph.microsoft.com/v1.0/applications" -Body ($appRegTmpl | ConvertTo-Json -Depth 10))
        $principal = Invoke-RestMethod -Method POST -Headers $headers -Uri  "https://graph.microsoft.com/v1.0/servicePrincipals" -Body (@{ "appId" = $app.appId } | ConvertTo-Json)
      }
      
      # Creating client secret
      $app = (Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/v1.0/applications/$($app.id)")
      
      foreach ($password in $app.passwordCredentials) {
        Write-Host "Deleting secret with id: $($password.keyId)"
        $body = @{
          "keyId" = $password.keyId
        }
        $ignore = Invoke-RestMethod -Method POST -Headers $headers -Uri "https://graph.microsoft.com/v1.0/applications/$($app.id)/removePassword" -Body ($body | ConvertTo-Json)
      }
      
      $body = @{
        "passwordCredential" = @{
          "displayName"= "Client Secret"
        }
      }
      $secret = (Invoke-RestMethod -Method POST -Headers $headers -Uri  "https://graph.microsoft.com/v1.0/applications/$($app.id)/addPassword" -Body ($body | ConvertTo-Json)).secretText
      
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
      APP_CLIENT_ID: scriptAppReg.properties.outputs.clientId
      APP_CLIENT_SECRET: scriptAppReg.properties.outputs.clientSecret
    }
  }
}
