@description('The groupname prefix for assignemt groups in ADDS')
param ad_assignmentgroup_prefix string = 'GG_'

@description('The ou path in LDAP notation for ADDS group objects')
param ad_groupoupath string = 'ou=ServiceNow,ou=organisationgroups,ou=groups,ou=datacenter,ou=chwid,dc=chwid,dc=local'

@secure()
@description('The username of the ADDS user (admin)')
param ad_username string = 'CHWID\\sa-widup'

@description('The key vault secret name for the username of the ADDS user (admin)')
param ad_username_kvsecretname string = 'adusername'

@description('The ou path in LDAP notation for ADDS user objects')
param ad_useroupath string = 'ou=users,ou=onprem,ou=chwid,dc=chwid,dc=local'

@secure()
@description('The password of the ADDS user (admin)')
param ad_userpassword string = 'sdge48%bxV5$^C'

@description('The key vault secret name for the password of the ADDS user (admin)')
param ad_userpassword_kvsecretname string = 'aduserpassword'

@description('The base url of the function app')
param api_base_url string = 'https://wid-func-widup-001.azurewebsites.net/'

@description('The name of the the application insights resource')
param application_insigths_name string = 'wid-appi-widup-001'

@description('The name of the app service plan for the Azure function')
param app_service_plan_name string = 'wid-plan-widup-001'

@description('The max number of bc records processed in one batch')
param bc_queuebatchsize int = 300

@description('The id of the service principal for accessing the bc environment')
param bc_sp_clientid string = 'fb69fb7c-6a0c-41bf-b3d0-2d56fef22081'

@description('The name of the bc service principal secret in key vault')
param bc_sp_kvsecretname string = 'bcsecret'

@description('The bc api url for the debitor (customers) entity')
param bc_url_debitor string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/customer/v1.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/customers'

@description('The bc api url for the employe entity')
param bc_url_employee string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/employees'

@description('The bc api url for the jobheads entity')
param bc_url_jobhead string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobsHeaders'

@description('The bc api url for the jobledger entity')
param bc_url_jobledger string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobLedgerEntries'

@description('The bc api url for the jobplanninglines entity')
param bc_url_jobplanningline string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobPlanningLines'

@description('The bc api url for the jobtasks entity')
param bc_url_jobtask string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobTasks'

@description('The bc api url for the jobworksheet entity')
param bc_url_jobworksheet string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/journals(###journalid###)/jobWorksheets'

@description('The bc api url for the journal entity')
param bc_url_journal string = 'https://api.businesscentral.dynamics.com/v2.0/PROD/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/journals'

@description('The url of the CRM environment')
param crm_environment_url string = 'https://wagner.crm4.dynamics.com'

@description('The dataverse environment id')
param dv_environment_id string = 'ee997d09-2c47-e201-9b9b-8d04658d4258'

@description('The dataverse publisher prefix')
param dv_environment_publisherprefix string = 'widup'

@description('The dataverse solution name')
param dv_environment_solutionname string = 'widup'

@description('The url of the Dataverse environment')
param dv_environment_url string = 'https://org0c5d3056.crm17.dynamics.com'

@description('The dv api url for the debitor entity (the environment url will pe prefixed to this)')
param dv_url_debitor string = '/api/data/v9.2/widup_debitors'

@description('The dv api url for the employee entity (the environment url will pe prefixed to this)')
param dv_url_employee string = '/api/data/v9.2/widup_employees'

@description('The dv api url for the jobheads entity (the environment url will pe prefixed to this)')
param dv_url_jobhead string = '/api/data/v9.2/widup_jobheads'

@description('The dv api url for the jobplanninglines entity (the environment url will pe prefixed to this)')
param dv_url_jobplanningline string = '/api/data/v9.2/widup_jobplanninglines'

@description('The dv api url for the jobtasks entity (the environment url will pe prefixed to this)')
param dv_url_jobtask string = '/api/data/v9.2/widup_jobtasks'

@description('The dv api url for the journal entity (the environment url will pe prefixed to this)')
param dv_url_journal string = '/api/data/v9.2/widup_journals'

@description('The dv api url for the statistic entity (the environment url will pe prefixed to this)')
param dv_url_statistic string = '/api/data/v9.2/widup_statistics'

@description('The dv api url for the statisticrun entity (the environment url will pe prefixed to this)')
param dv_url_statisticrun string = '/api/data/v9.2/widup_statisticruns'

@description('The name of the Azure function app')
param function_app_name string = 'wid-func-widup-001'

@description('The resource id of the subnet for the function app integration')
param function_app_vnet_integration_subnet_id string = ''

@description('The name of the hybrid connection')
param hybrid_connection_name string = 'wid-rlhc-widup-001'

@description('The fqdn of the ad server name used in the hybrid connection')
param hycon_adserver_name string = 'scwidapp11'

@description('The port of the ad server used in the hybrid connection')
param hycon_adserver_port int = 5986

@description('The id of the vault administrator role')
param keyvaultadministrator_role_id string = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

@description('The id of the vault secrets officer role')
param keyvaultsecretsofficer_role_id string = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

@description('The id of the vault secrets user role')
param keyvaultsecretsuser_role_id string = '4633458b-17de-408a-b874-0445c86b69e6'

@description('The name of the Azure keyvault')
param keyvault_name string = 'wid-kv-widup-001'

@description('Location for resources of the deployment')
param location string = 'switzerlandnorth'

@description('The name of the log analytics workspace used by application inights resource the Azure function')
param log_analytics_workspace_name string = 'wid-law-widup-001'

@description('The name of the managed identity of the Azure function')
param managed_identity_name string = 'wid-id-widup-001'

@description('The name of the relay namespace for the hybrid connection')
param relay_namespace_name string = 'wid-rln-widup-001'

@description('The name of the resource group for the resources of the deployment')
param resource_group_name string = 'wid-rg-widup-001'

@description('The SKU family name for the app service plan')
param service_plan_sku_family string = 'EP'

@description('The SKU name for the app service plan')
param service_plan_sku_name string = 'EP1'

@description('The tier name for the app service plan')
param service_plan_sku_tier string = 'ElasticPremium'

@description('The name of the admin2 token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_admin2_token_kvsecretname string = 'snowadmin2token'

@description('The name of the admin token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_admin_token_kvsecretname string = 'snowadmintoken'

@description('The snow api table url for the debitor entity; this url is used to check for consistency')
param snow_table_url_debitor string = 'https://wagner.service-now.com/api/now/v2/table/core_company'

@description('The snow api table url for the jobhead entity; this url is used to check for consistency')
param snow_table_url_jobhead string = 'https://wagner.service-now.com/api/now/v2/table/ast_service'

@description('The snow api table url for the jobplanningline entity; this url is used to check for consistency')
param snow_table_url_jobplanningline string = 'https://wagner.service-now.com/api/now/v2/table/u_cmdb_ci_project_plan_item'

@description('The snow api table url for the jobtask entity; this url is used to check for consistency')
param snow_table_url_jobtask string = 'https://wagner.service-now.com/api/now/v2/table/u_article'

@description('The snow api table url for the timecard entity; this url is used to check for consistency')
param snow_table_url_journal string = 'https://wagner.service-now.com/api/now/v2/table/time_card'

@description('The snow api table url for the outbound message entity; this url is used to check for consistency')
param snow_table_url_outbound_message string = 'https://wagner.service-now.com/api/now/v2/table/u_if_outbound_message'

@description('The name of the basic token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_token_kvsecretname string = 'snowtoken'

@description('The snow api url for the debitor entity')
param snow_url_debitor string = 'https://wagner.service-now.com/api/now/import/u_import_msbc_debitor'

@description('The snow api url for the jobheads entity')
param snow_url_jobhead string = 'https://wagner.service-now.com/api/now/import/u_import_msbc_projektkopf'

@description('The snow api url for the jobplanninglines entity')
param snow_url_jobplanningline string = 'https://wagner.service-now.com/api/now/import/u_import_msbc_projektplanzeile'

@description('The snow api url for the jobtasks entity')
param snow_url_jobtask string = 'https://wagner.service-now.com/api/now/import/u_import_msbc_projektaufgabe'

@description('The id of the storage blob data contributor role')
param storageblobdatacontributor_role_id string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

@description('The id of the storage queue data contributror role')
param storagequeuedatacontributor_role_id string = '974c5e8b-45b9-4653-ba55-5f855dd0fb88'

@description('The id of the storage table data contributror role')
param storagetabledatacontributor_role_id string = '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'

@description('The name of the ad queue')
param storage_account_ad_queue_name string = 'adqueue'

@description('The name of the schema table')
param storage_account_apischema_table_name string = 'apischema'

@description('The name of the bc queue')
param storage_account_bc_queue_name string = 'bcqueue'

@description('The name of the cache blob container')
param storage_account_cache_container_name string = 'cacheblob'

@description('The name of the department table')
param storage_account_department_table_name string = 'department'

@description('The name of the dv queue')
param storage_account_dv_queue_name string = 'dvqueue'

@description('The name of the job queue')
param storage_account_job_queue_name string = 'jobqueue'

@description('The name of the storage account')
param storage_account_name string = 'widstwidup001'

@description('The name of the SKU for the storage account')
param storage_account_sku_name string = 'Standard_LRS'

@description('The name of the snow queue')
param storage_account_snow_queue_name string = 'snowqueue'

@description('The name of the syncjob table')
param storage_account_syncjob_table_name string = 'syncjob'

@description('Target subscription id')
param target_subscription_id string = '6178e425-5861-4d3d-99e2-31bb2175fb11'

@description('Target tenant id')
param tenant_id string = 'f72f8eb9-210d-48d8-b271-69513506293e'

@description('Target tenant name')
param tenant_name string = 'wagner.ch'




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
  }
}

//Managed identity and role assignements
resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
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

resource mi_keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, mi.id, keyvaultsecretsuser_role_id)
  scope: kv
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',keyvaultsecretsuser_role_id)
    principalType: 'ServicePrincipal'
  }
}

