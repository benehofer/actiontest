param currentTime string = utcNow()
/*
The storage account contains all storage services that are used by the WIDup interface. 
These include the storage queues that form the interface cycle, the storage tables 
that are used to store the status of the jobs and the storage blobs that are used 
n conjunction with the queues to store the data records that are sent via the interface.<br/>
A storage of type StorageV2 is used. Further information on Azure storage accounts can 
be found <a href='https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview' target='_blank'>here</a>.
*/
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
/*
The queueservice resource belongs to the storage account and configures it for the queue service. 
Further information on Azure storage queues can be found 
<a href='https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction' target='_blank'>here</a>.
*/
resource sa_queueService 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  name: 'default'
  parent: sa
}
/*
Each queue used by WIDup is created as a resource based on the queue service of the storage 
account. sa_queue1 is the central job queue <article: widup queue processing>.
*/
resource sa_queue1 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_job_queue_name
  parent: sa_queueService
}
/*
Each queue used by WIDup is created as a resource based on the queue service of the storage 
account. sa_queue2 is the queue for Service Now <article: widup queue processing>.
*/
resource sa_queue2 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_snow_queue_name
  parent: sa_queueService
}
/*
Each queue used by WIDup is created as a resource based on the queue service of the storage 
account. sa_queue3 is the queue for Dataverse <article: widup queue processing>.
*/
resource sa_queue3 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_dv_queue_name
  parent: sa_queueService
}
/*
Each queue used by WIDup is created as a resource based on the queue service of the storage 
account. sa_queue4 is the queue for Business central <article: widup queue processing>.
*/
resource sa_queue4 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_bc_queue_name
  parent: sa_queueService
}
/*
Each queue used by WIDup is created as a resource based on the queue service of the storage 
account. sa_queue5 is the queue for the Active Directory Domain Services system <article: widup queue processing>.
*/
resource sa_queue5 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  name: storage_account_ad_queue_name
  parent: sa_queueService
}
/*
The tableservice resource belongs to the storage account and configures it for the table service. 
Further information on Azure storage tables can be found 
<a href='https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview' target='_blank'>here</a>.
*/
resource sa_tableService 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
  name: 'default'
  parent: sa
}
/*
Each table used by WIDup is created as a resource based on the table service of the storage 
account. sa_table1 is the table for the API schema.
*/
resource sa_table1 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_apischema_table_name
  parent: sa_tableService
}
/*
Each table used by WIDup is created as a resource based on the table service of the storage 
account. sa_table2 is the table for the syncjob configuration and state.
*/
resource sa_table2 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_syncjob_table_name
  parent: sa_tableService
}
/*
Each table used by WIDup is created as a resource based on the table service of the storage 
account. sa_table3 is the table for the additional department data for the ADDS system.
*/
resource sa_table3 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_department_table_name
  parent: sa_tableService
}
/*
Each table used by WIDup is created as a resource based on the table service of the storage 
account. sa_table4 is the table for the additional location data for the ADDS system.
*/
resource sa_table4 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
  name: storage_account_location_table_name
  parent: sa_tableService
}
/*
The blobservice resource belongs to the storage account and configures it for the blob service. 
Further information on Azure storage blobs can be found 
<a href='https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction' target='_blank'>here</a>.
*/
resource sa_blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: sa
}
/*
Each container used by WIDup is created as a resource based on the blob service of the storage 
account. sa_container1 is the blob container for the queue cache data <article:queue worker processing>.
*/
resource sa_container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: storage_account_cache_container_name
  parent: sa_blobService
  properties: {
    publicAccess:'None'
    metadata: {}
  }
}
/*
An Azure Log analytics workspace is a storage solution for storing log data. A workspace consists of 
several tables into which data from different sources is written. WIDup uses the log analytics workspace 
to store the logs that are collected via application insights<br/>Further information on log analytics 
workspaces is available <a href='https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview' target='_blank'>here</a>.
*/
resource aiWS 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: log_analytics_workspace_name
  location: location
}
/*
Azure application insights is a monitoring solution for live web applications. With application insights, 
metrics, logs and alerts from web applications can be easily collected and analysed in a central location. 
Application insights uses a log analytics workspace as a data repository. WIDup uses application insights to 
collect data from the function app.<br/>More information about application insights can be found <a href='https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview' target='_blank'>here</a>.
*/
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
/*
Azure managed identities enable an identity to be assigned to an application. The identity is managed by Entra ID 
and can be used by the application to access RBAC-managed resources. This can solve the classic "chicken and egg" 
problem in the authentication and authorisation of distributed web applications, among other things. WIDup uses 
managed identities for the Function App, among other things.<br/>For more information on managed identities, 
see <a href='https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview' target='_blank'>here</a>.
*/
resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managed_identity_name
  location: location
}
/*
In Azure, authorisations for elements are implemented using the RBAC (role-based access control) concept. RBAC 
is formulated in rules, a single RBAC rule always contains 3 elements: a security principal, a role and a scope. 
The rule grants the security principal (e.g. a user account or a managed identity) the authorisations on the 
scope that are summarised in the role. For the functions of WIDup, the managed identity <section:managedidentity> 
requires rights to various resources of the solution, e.g. the right to read secrets in a key vault.<br/>Further 
information on the topic of RBAC in Azure can be found 
<a href='https://learn.microsoft.com/en-us/azure/role-based-access-control/overview' target='_blank'>here</a>.<br/>The 
RBAC rule below grants the Managed identity access to the tables in the storage account <section:storage>.
*/
resource mi_storageTableDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storagetabledatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storagetabledatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
/*
In Azure, authorisations for elements are implemented using the RBAC (role-based access control) concept. RBAC 
is formulated in rules, a single RBAC rule always contains 3 elements: a security principal, a role and a scope. 
The rule grants the security principal (e.g. a user account or a managed identity) the authorisations on the 
scope that are summarised in the role. For the functions of WIDup, the managed identity <section:managedidentity> 
requires rights to various resources of the solution, e.g. the right to read secrets in a key vault.<br/>Further 
information on the topic of RBAC in Azure can be found 
<a href='https://learn.microsoft.com/en-us/azure/role-based-access-control/overview' target='_blank'>here</a>.<br/>The 
RBAC rule below grants the Managed identity access to the blobs in the storage account <section:storage>.
*/
resource mi_role_storageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storageblobdatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storageblobdatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
/*
In Azure, authorisations for elements are implemented using the RBAC (role-based access control) concept. RBAC 
is formulated in rules, a single RBAC rule always contains 3 elements: a security principal, a role and a scope. 
The rule grants the security principal (e.g. a user account or a managed identity) the authorisations on the 
scope that are summarised in the role. For the functions of WIDup, the managed identity <section:managedidentity> 
requires rights to various resources of the solution, e.g. the right to read secrets in a key vault.<br/>Further 
information on the topic of RBAC in Azure can be found 
<a href='https://learn.microsoft.com/en-us/azure/role-based-access-control/overview' target='_blank'>here</a>.<br/>The 
RBAC rule below grants the Managed identity access to the queues in the storage account <section:storage>.
*/
resource mi_storageQueueDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, mi.id, storagequeuedatacontributor_role_id)
  scope: sa
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',storagequeuedatacontributor_role_id)
    principalType: 'ServicePrincipal'
  }
}
/*
In Azure, authorisations for elements are implemented using the RBAC (role-based access control) concept. RBAC 
is formulated in rules, a single RBAC rule always contains 3 elements: a security principal, a role and a scope. 
The rule grants the security principal (e.g. a user account or a managed identity) the authorisations on the 
scope that are summarised in the role. For the functions of WIDup, the managed identity <section:managedidentity> 
requires rights to various resources of the solution, e.g. the right to read secrets in a key vault.<br/>Further 
information on the topic of RBAC in Azure can be found 
<a href='https://learn.microsoft.com/en-us/azure/role-based-access-control/overview' target='_blank'>here</a>.<br/>The 
RBAC rule below grants the Managed identity access to the secrets in the key vault <section:keyvault>.
*/
resource mi_keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, mi.id, keyvaultsecretsuser_role_id)
  scope: kv
  properties: {
    principalId: mi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',keyvaultsecretsuser_role_id)
    principalType: 'ServicePrincipal'
  }
}
/*
Azure managed identities enable an identity to be assigned to an application. The identity is managed by Entra ID 
and can be used by the application to access RBAC-managed resources. This can solve the classic "chicken and egg" 
problem in the authentication and authorisation of distributed web applications, among other things. The mi_swa managed 
identity is used for the static web app.<br/>For more information on managed identities, 
see <a href='https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview' target='_blank'>here</a>.
*/
resource mi_swa 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: swa_managed_identity_name
  location: location
}
/*
In Azure, authorisations for elements are implemented using the RBAC (role-based access control) concept. RBAC 
is formulated in rules, a single RBAC rule always contains 3 elements: a security principal, a role and a scope. 
The rule grants the security principal for the static web app access to the secrets of the key vault.<br/>Further 
information on the topic of RBAC in Azure can be found 
<a href='https://learn.microsoft.com/en-us/azure/role-based-access-control/overview' target='_blank'>here</a>.<br/>The 
RBAC rule below grants the Managed identity access to the secrets in the key vault <section:keyvault>.
*/
resource mi_swa_keyVaultSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, mi_swa.id, keyvaultsecretsuser_role_id)
  scope: kv
  properties: {
    principalId: mi_swa.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions',keyvaultsecretsuser_role_id)
    principalType: 'ServicePrincipal'
  }
}
/*
The compute resources for a function app are made available as an app service plan in Azure. The app service plan defines, 
among other things, the region and the performance of the compute resources. WIDup uses an App service plan for the funnction 
app, which is the functional centre of the interface.<br/>Further information on App service plans can be found 
<a href='https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans' target='_blank'>here</a>.
*/
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
/*
The function app contains the entire content code of the WIDup interface. The code is divided into various 'functions', which 
in turn run independently of each other. WIDup thus follows a micro-service architecture paradigm. The function app is executed 
on the compute resources of the app service plan.<br/>Further information on Azure Functions can be found 
<a href='https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview?pivots=programming-language-csharp' target='_blank'>here</a>.
*/
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
/*
The networkconfig resource is a sub-resource of the function app resource (sites). It is used to define a VNET 
integration for the function app. A VNET integration allows the function app to reach resources that participate 
in an Azure virtual network (e.g. a virtual machine). WIDup does not currently use the VNET integration; the resource is only deployed if an ID for the subnet into which the function app is to be integrated is specified 
in the parameters for the bicep file.<br/>For more information on network options for function apps, see 
<a href='https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options?tabs=azure-portal' target='_blank'>here</a>.
*/
resource networkConfig 'Microsoft.Web/sites/networkConfig@2022-03-01' = if (!empty(function_app_vnet_integration_subnet_id)) {
  parent: app
  name: 'virtualNetwork'
  properties: {
    //subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', function_app_vnet_name, function_app_snet_name)
    subnetResourceId: function_app_vnet_integration_subnet_id
    swiftSupported: true
  }
}
/*
Azure Relay services make it possible to securely make network connections from local (on-premise, non-cloud) services 
available in the cloud. Microsoft Relay establishes https-based bidirectional sockets for this purpose, which can then 
be accessed from cloud resources. Further information on the Microsoft Relay service can be found at this 
<a href='https://learn.microsoft.com/en-us/azure/azure-relay/relay-what-is-it' target='_blank'>article</a>.<br/>WIDup 
uses Microsoft Relay to connect to the local ADDS server. The service that the ADDS server makes available in the 
cloud is the secure remote powershell port in this scenario.
*/
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
/*
The Authorisation Rule is a sub-resource of the Microsoft relay namespace. In this case, it defines which actions 
may be performed with the SAS key; we allow all possible actions here (listen, send, manage).<br/>Further information 
on authentication in Microsoft Relay can be found 
<a href='https://learn.microsoft.com/en-us/azure/azure-relay/relay-authentication-and-authorization' target='blank_'>here</a>.
*/
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
/*
The hybrid connection is a sub-resource of the Microsoft Relay Namespace. A hybrid connection defines the connection 
between a cloud resource and a (local) service released via Microsoft Relay. The hybrid connection is then referenced 
by the cloud resource that wants to use it; in our case, this is the function app that contains the code of the WIDup 
interface.
*/
resource hycon 'Microsoft.Relay/namespaces/hybridconnections@2021-11-01' = {
  parent: rns
  name: hybrid_connection_name
  properties: {
    requiresClientAuthorization: true
    userMetadata: '[{"key":"endpoint","value":"${hycon_adserver_name}:${hycon_adserver_port}"}]'
  }
}
/*
The networkruleset resource is a sub-resource of the Microsoft Relay namespace. The resource defines the local firewall of 
the Microsoft Relay services.
*/
resource rnsnrs 'Microsoft.Relay/namespaces/networkRuleSets@2021-11-01' = {
  parent: rns
  name: 'default'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    ipRules: []
  }
}
/*
The authorisation rules are sub-resources of the hybrid connection. They define which network actions are permitted 
on the respective hybrid connection. WIDup allows both actions, send and listen.
*/
resource hycconrule_listener 'Microsoft.Relay/namespaces/hybridconnections/authorizationrules@2021-11-01' = {
  parent: hycon
  name: 'defaultListener'
  properties: {
    rights: [
      'Listen'
    ]
  }
}
/*
The authorisation rules are sub-resources of the hybrid connection. They define which network actions are permitted 
on the respective hybrid connection. WIDup allows both actions, send and listen.
*/
resource hyconrule_sender 'Microsoft.Relay/namespaces/hybridconnections/authorizationrules@2021-11-01' = {
  parent: hycon
  name: 'defaultSender'
  properties: {
    rights: [
      'Send'
    ]
  }
}
/*
The relay resource is a sub-resource of the hybrid connection definition of the Azure Function App. It links the Azure 
Function App to a configured connection of the relay service and specifies the details of the connection, such as 
the target server address and TCP port <section:relay>.
*/
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
/*
Azure Key vaults are used for the secure storage of sensitive information such as passwords or client secrets. WIDup uses a 
key vault for precisely this purpose; we do not store all security-relevant parameters directly in the configuration of the 
function app, but rather as a secret in the key vault.<br/>Further information on Azure Key Vaults is available at this 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts' target='_blank'>link</a>.
*/
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
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The underlying 
secret contains the secret of the service principal used to access the business central environments.
*/
resource kvs_bcsecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: bc_sp_kvsecretname
  properties: {
    value: 'dummy'
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The underlying 
secret contains the basic authentication token to access the import tables of the service now environment.
*/
resource kvs_snowtoken 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: snow_token_kvsecretname
  properties: {
    value: 'dummy'
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The underlying 
secret contains the basic authentication token of the api admin user to access the service now table api.
*/
resource kvs_snowadmintoken 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: snow_admin_token_kvsecretname
  properties: {
    value: 'dummy'
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The underlying 
secret contains the user name for the connection to the local ADDS server <section:ad_queueworker>.
*/
resource kvs_adusername 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: ad_username_kvsecretname
  properties: {
    value: ad_username
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The underlying 
secret contains the user password for the connection to the local ADDS server <section:ad_queueworker>.
*/
resource kvs_aduserpassword 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: ad_userpassword_kvsecretname
  properties: {
    value: ad_userpassword
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The secret 
contains the client id (application id) of the registered application in Entra ID; the registered application is created via 
the deployment script resource. The client id is an output parameter of the script resource.
*/
resource kvs_clientID 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_id_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientId
  }
}
/*
WIDup uses secrets in key vaults to store sensitive information. Further information on Azure key vault secrets can be found 
<a href='https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets' target='_blank'>here</a>.<br/>The secret contains 
the client secret of the registered application in Entra ID; the registered application is created via the deployment script 
resource. The client secret is an output parameter of the script resource. In order to maintain the idempotent characteristics 
of the entire bicep rollout, the secret is reset with each run and stored both in the key vault and as a parameter of the static 
web app.
*/
resource kvs_clientSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: swa_registered_app_client_secret_kvsecretname
  properties: {
      value: scriptAppReg.properties.outputs.clientSecret
  }
}
/*
The Deployment Script Resource is used to create the Entra ID registered application. This is stored as an authentication provider 
in the static web app. In this way, a login to Entra ID can be configured for the static web app.<br/>Bicep does not offer any 
native options for managing entities in Entra ID, as this type of resource is not managed via ARM. The deployment scirpt resource 
therefore uses Graph REST calls to manage the registered application, the associated sercvice principal and the secrets.<br/>The 
script resource itself uses a managed identity to log on to Graph ('bicep_managed_identity_name'). This MI is created dynamically 
in the context of the CI/CD pipelines before the bicep rollout is executed and authorised accordingly ('Application administrator' 
role). After execution, this managed identity is deleted again, i.e. it only exists during the execution of the bicep deployment process.
*/
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
/*
The static web app resource is used to publish the documentation for WIDup. The documentation is part of the overall 
solution and is regenerated each time the CI/CD pipeline is run.<br/>Access to the documentation content requires a 
login to Entra ID. The Static web app is therefore linked to the registered application that is created for this purpose 
via the configuration settings 'APP_CLIENT_ID' and 'APP_CLIENT_SECRET'.
*/
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
