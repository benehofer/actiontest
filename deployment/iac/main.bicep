@description('The groupname prefix for assignemt groups in ADDS')
param ad_assignmentgroup_prefix string = 'GG_'

@description('The ou path in LDAP notation for ADDS group objects')
param ad_groupoupath string = 'cn=Users,dc=testwid,dc=local'

@secure()
@description('The username of the ADDS user (admin)')
param ad_username string = 'admin'

@description('The key vault secret name for the username of the ADDS user (admin)')
param ad_username_kvsecretname string = 'adusername'

@description('The ou path in LDAP notation for ADDS user objects')
param ad_useroupath string = 'cn=Users,dc=testwid,dc=local'

@secure()
@description('The password of the ADDS user (admin)')
param ad_userpassword string = 'dummy'

@description('The key vault secret name for the password of the ADDS user (admin)')
param ad_userpassword_kvsecretname string = 'aduserpassword'

@description('The base url of the function app')
param api_base_url string = 'https://func-hofb-wup-tst-sn-01.azurewebsites.net/'

@description('The name of the the application insights resource')
param application_insigths_name string = 'appi-hofb-wup-tst-sn-01'

@description('The name of the app service plan for the Azure function')
param app_service_plan_name string = 'plan-hofb-wup-tst-sn-01'

@description('The max number of bc records processed in one batch')
param bc_queuebatchsize string = '300'

@description('The id of the service principal for accessing the bc environment')
param bc_sp_clientid string = 'fb69fb7c-6a0c-41bf-b3d0-2d56fef22081'

@description('The name of the bc service principal secret in key vault')
param bc_sp_kvsecretname string = 'bcsecret'

@description('The bc api url for the debitor (customers) entity')
param bc_url_debitor string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/customer/v1.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/customers'

@description('The bc api url for the departments entity')
param bc_url_departments string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/swsDepartments'

@description('The bc api url for the departmentsupervisors entity')
param bc_url_departmentsupervisors string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/swsDepartmentSupervisors'

@description('The bc api url for the employe entity')
param bc_url_employee string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/employees'

@description('The bc api url for the employeedimensions entity')
param bc_url_employeedimensions string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/salary/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/swsEmployeeDimensions'

@description('The bc api url for the jobheads entity')
param bc_url_jobhead string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobsHeaders'

@description('The bc api url for the jobledger entity')
param bc_url_jobledger string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobLedgerEntries'

@description('The bc api url for the jobplanninglines entity')
param bc_url_jobplanningline string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobPlanningLines'

@description('The bc api url for the jobtasks entity')
param bc_url_jobtask string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/jobTasks'

@description('The bc api url for the jobworksheet entity')
param bc_url_jobworksheet string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/journals(###journalid###)/jobWorksheets'

@description('The bc api url for the journal entity')
param bc_url_journal string = 'https://api.businesscentral.dynamics.com/v2.0/DEV/api/beeDynamics/job/v2.0/companies(2cbb34a6-23b4-ed11-9a88-002248f315c6)/journals'

@description('The name of the managed identity for the bicep deployment script')
param bicep_managed_identity_name string = 'id-hofb-wupbcp-tst-sn-01'

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

@description('The dv api url for the recorddiff entity (the environment url will pe prefixed to this)')
param dv_url_recorddiff string = '/api/data/v9.2/widup_recorddiff'

@description('The dv api url for the statistic entity (the environment url will pe prefixed to this)')
param dv_url_statistic string = '/api/data/v9.2/widup_statistics'

@description('The dv api url for the statisticrun entity (the environment url will pe prefixed to this)')
param dv_url_statisticrun string = '/api/data/v9.2/widup_statisticruns'

@description('The name of the Azure function app')
param function_app_name string = 'func-hofb-wup-tst-sn-01'

@description('The resource id of the subnet for the function app integration')
param function_app_vnet_integration_subnet_id string = '/subscriptions/281a469b-3f25-4913-9644-efb65d48a83f/resourceGroups/rg-hofb-net-shd-sn-01/providers/Microsoft.Network/virtualNetworks/vnet-hofb-net-shd-sn-01/subnets/snet-with-webserverfarm-delegation'

@description('The name of the hybrid connection')
param hybrid_connection_name string = 'hycon-hofb-wup-tst-sn-01'

@description('The fqdn of the ad server name used in the hybrid connection')
param hycon_adserver_name string = 'adserver'

@description('The port of the ad server used in the hybrid connection')
param hycon_adserver_port int = 5986

@description('The id of the vault administrator role')
param keyvaultadministrator_role_id string = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

@description('The id of the vault secrets officer role')
param keyvaultsecretsofficer_role_id string = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

@description('The id of the vault secrets user role')
param keyvaultsecretsuser_role_id string = '4633458b-17de-408a-b874-0445c86b69e6'

@description('The name of the Azure keyvault')
param keyvault_name string = 'vault-hofb-wup-tst-sn-01'

@description('Location for resources of the deployment')
param location string = 'switzerlandnorth'

@description('The name of the log analytics workspace used by application inights resource the Azure function')
param log_analytics_workspace_name string = 'log-hofb-wup-tst-sn-01'

@description('The name of the managed identity of the Azure function')
param managed_identity_name string = 'id-hofb-wup-tst-sn-01'

@description('The maximum number of minutes an item is allowed to stay in a non-poison queue')
param mth_max_minutes_item_in_queue int = 30

@description('The maximum age of a diff record in the recorddiff dataverse table')
param mth_max_minutes_recorddiff_age int = 60

@description('The maximum age of a statisticrun records in the statisticrun dataverse table')
param mth_max_minutes_statisticrun_age int = 45

@description('The maximum age of the statisticrun record for timecard errors in the statisticrun dataverse table')
param mth_max_minutes_statisticrun_tcerrors_age int = 30

@description('The maximum number of minutes a syncjob is allowed to be behind its schedule')
param mth_max_minutes_syncjob_delay int = 15

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

@description('The name of the admin2 token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_admin2_token_kvsecretname string = 'snowadmin2token'

@description('The name of the admin token for SNOW api authentication (user:pass in base64) secret in key vault')
param snow_admin_token_kvsecretname string = 'snowadmintoken'

@description('The snow api table url for the debitor entity; this url is used to check for consistency')
param snow_table_url_debitor string = ''

@description('The snow api table url for the jobhead entity; this url is used to check for consistency')
param snow_table_url_jobhead string = ''

@description('The snow api table url for the jobplanningline entity; this url is used to check for consistency')
param snow_table_url_jobplanningline string = ''

@description('The snow api table url for the jobtask entity; this url is used to check for consistency')
param snow_table_url_jobtask string = ''

@description('The snow api table url for the timecard entity; this url is used to check for consistency')
param snow_table_url_journal string = ''

@description('The snow api table url for the outbound message entity; this url is used to check for consistency')
param snow_table_url_outbound_message string = ''

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

@description('The name of the registered application for the authentication of the static web app')
param static_web_app_name string = 'swa-hofb-wup-tst-sn-01'

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

@description('The name of the location table')
param storage_account_location_table_name string = 'location'

@description('The name of the storage account')
param storage_account_name string = 'sahofbwuptstsn01'

@description('The name of the SKU for the storage account')
param storage_account_sku_name string = 'Standard_LRS'

@description('The name of the snow queue')
param storage_account_snow_queue_name string = 'snowqueue'

@description('The name of the syncjob table')
param storage_account_syncjob_table_name string = 'syncjob'

@description('The name of the managed identity of the static web app')
param swa_managed_identity_name string = 'id-hofb-wupswa-tst-sn-01'

@description('The key vault secret name for the username of the ADDS user (admin)')
param swa_registered_app_client_id_kvsecretname string = 'swa-app-client-id'

@description('The key vault secret name for the username of the ADDS user (admin)')
param swa_registered_app_client_secret_kvsecretname string = 'swa-app-client-secret'

@description('The name of the registered application for the authentication of the static web app')
param swa_registered_app_name string = 'app-hofb-wupswa-tst-sn-01'

@description('Target subscription id')
param target_subscription_id string = '281a469b-3f25-4913-9644-efb65d48a83f'

@description('Target tenant id')
param tenant_id string = 'f6819965-9fb4-4295-b341-4d250431078c'

@description('Target tenant name')
param tenant_name string = 'wid.dev'



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

