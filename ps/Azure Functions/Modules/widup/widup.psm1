function Initialize-WIDUp() {
    param(

    )
    if ($null -ne $env:crm_environment_url) {
        $global:crmEnvironmentUrl=$env:crm_environment_url
    } else {
        $global:crmEnvironmentUrl=''
    }

    if ($null -ne $env:dv_environment_url) {
        $global:dvEnvironmentUrl=$env:dv_environment_url
    } else {
        $global:dvEnvironmentUrl=''
    }
    
    if ($null -ne $env:dv_environment_publisherprefix) {
        $global:dvEnvironmentPublisherPrefix=$env:dv_environment_publisherprefix
    } else {
        $global:dvEnvironmentPublisherPrefix=''
    }
    
    if ($null -ne $env:tenant_id) {
        $global:tenantid=$env:tenant_id
    } else {
        $global:tenantid=''
    }   
    if ($null -ne $env:API_BASE_URL) {
        $global:apiBaseUrl=$env:API_BASE_URL
    } else {
        $global:apiBaseUrl=''
    }
    if ($null -ne $env:apischema_table_name) {
        $global:apischematablename=$env:apischema_table_name
    } else {
        $global:apischematablename=''
    }

    if ($null -ne $env:syncjob_table_name) {
        $global:syncjobtablename=$env:syncjob_table_name
    } else {
        $global:syncjobtablename=''
    }

    if ($null -ne $env:department_table_name) {
        $global:departmenttablename=$env:department_table_name
    } else {
        $global:departmenttablename=''
    }
    if ($null -ne $env:TABLE_STORAGE_URI) {
        $global:tableStorageUri=$env:TABLE_STORAGE_URI
    } else {
        $global:tableStorageUri=''
    }

    if ($null -ne $env:QUEUE_STORAGE_URI) {
        $global:queueStorageUri=$env:QUEUE_STORAGE_URI
    } else {
        $global:queueStorageUri=''
    }

    if ($null -ne $env:JOB_QUEUE_NAME) {
        $global:jobQueueName=$env:JOB_QUEUE_NAME
    } else {
        $global:jobQueueName=''
    }

    if ($null -ne $env:SNOW_QUEUE_NAME) {
        $global:snowQueueName=$env:SNOW_QUEUE_NAME
    } else {
        $global:snowQueueName=''
    }

    if ($null -ne $env:DV_QUEUE_NAME) {
        $global:dvQueueName=$env:DV_QUEUE_NAME
    } else {
        $global:dvQueueName=''
    }

    if ($null -ne $env:BC_QUEUE_NAME) {
        $global:bcQueueName=$env:BC_QUEUE_NAME
    } else {
        $global:bcQueueName=''
    }

    if ($null -ne $env:BC_QUEUE_BATCH_SIZE) {
        $global:bcQueueBatchSize=$env:BC_QUEUE_BATCH_SIZE
    } else {
        $global:bcQueueBatchSize=300
    }

    if ($null -ne $env:AD_QUEUE_NAME) {
        $global:adQueueName=$env:AD_QUEUE_NAME
    } else {
        $global:adQueueName=''
    }

    if ($null -ne $env:VAULT_AUTHENTICATION_URI) {
        $global:vaultAuthenticationUrl=$env:VAULT_AUTHENTICATION_URI
    } else {
        $global:vaultAuthenticationUrl="https://vault.azure.net"
    }

    if ($null -ne $env:VAULT_URI) {
        $global:vaultUrl=$env:VAULT_URI
    } else {
        $global:vaultUrl=""
    }

    if ($null -ne $env:bc_sp_clientid) {
        $global:bcspclientid=$env:bc_sp_clientid
    } else {
        $global:bcspclientid=''
    }

    if ($null -ne $env:bc_sp_kvsecretname) {
        $global:bcspkvsecretname=$env:bc_sp_kvsecretname
    } else {
        $global:bcspkvsecretname=''
    }

    if ($null -ne $env:bc_url_jobhead) {
        $global:bcurljobhead=$env:bc_url_jobhead
    } else {
        $global:bcurljobhead=''
    }

    if ($null -ne $env:bc_url_jobtask) {
        $global:bcurljobtask=$env:bc_url_jobtask
    } else {
        $global:bcurljobtask=''
    }

    if ($null -ne $env:bc_url_jobplanningline) {
        $global:bcurljobplanningline=$env:bc_url_jobplanningline
    } else {
        $global:bcurljobplanningline=''
    }

    if ($null -ne $env:bc_url_debitor) {
        $global:bcurldebitor=$env:bc_url_debitor
    } else {
        $global:bcurldebitor=''
    }

    if ($null -ne $env:bc_url_journal) {
        #$global:bcurljournal=$env:bc_url_journal.replace("###singlequote###","'")
        $global:bcurljournal=$env:bc_url_journal
    } else {
        $global:bcurljournal=''
    }

    if ($null -ne $env:bc_url_jobworksheet) {
        #$global:bcurljournal=$env:bc_url_journal.replace("###singlequote###","'")
        $global:bcurljobworksheet=$env:bc_url_jobworksheet
    } else {
        $global:bcurljobworksheet=''
    }

    if ($null -ne $env:bc_url_employee) {
        $global:bcurlemployee=$env:bc_url_employee
    } else {
        $global:bcurlemployee=''
    }

    if ($null -ne $env:bc_url_jobledger) {
        $global:bcurljobledger=$env:bc_url_jobledger
    } else {
        $global:bcurljobledger=''
    }

    if ($null -ne $env:snow_token_kvsecretname) {
        $global:snowtokenkvsecretname=$env:snow_token_kvsecretname
    } else {
        $global:snowtokenkvsecretname=''
    }

    if ($null -ne $env:snow_admin_token_kvsecretname) {
        $global:snowadmintokenkvsecretname=$env:snow_admin_token_kvsecretname
    } else {
        $global:snowadmintokenkvsecretname=''
    }    

    if ($null -ne $env:snow_url_jobhead) {
        $global:snowurljobhead=$env:snow_url_jobhead
    } else {
        $global:snowurljobhead=''
    }

    if ($null -ne $env:snow_url_jobtask) {
        $global:snowurljobtask=$env:snow_url_jobtask
    } else {
        $global:snowurljobtask=''
    }

    if ($null -ne $env:snow_url_jobplanningline) {
        $global:snowurljobplanningline=$env:snow_url_jobplanningline
    } else {
        $global:snowurljobplanningline=''
    }

    if ($null -ne $env:snow_url_debitor) {
        $global:snowurldebitor=$env:snow_url_debitor
    } else {
        $global:snowurldebitor=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_DEBITOR) {
        $global:snowtableurldebitor=$env:SNOW_TABLE_URL_DEBITOR
    } else {
        $global:snowtableurldebitor=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_JOBHEAD) {
        $global:snowtableurljobhead=$env:SNOW_TABLE_URL_JOBHEAD
    } else {
        $global:snowtableurljobhead=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_JOBTASK) {
        $global:snowtableurljobtask=$env:SNOW_TABLE_URL_JOBTASK
    } else {
        $global:snowtableurljobtask=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_JOBPLANNINGLINE) {
        $global:snowtableurljobplanningline=$env:SNOW_TABLE_URL_JOBPLANNINGLINE
    } else {
        $global:snowtableurljobplanningline=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_JOURNAL) {
        $global:snowtableurljournal=$env:SNOW_TABLE_URL_JOURNAL
    } else {
        $global:snowtableurljournal=''
    }

    if ($null -ne $env:SNOW_TABLE_URL_OUTBOUND_MESSAGE) {
        $global:snowtableurloutboundmessage=$env:SNOW_TABLE_URL_OUTBOUND_MESSAGE
    } else {
        $global:snowtableurloutboundmessage=''
    }

    if ($null -ne $env:dv_url_jobhead) {
        $global:dvurljobhead=$env:dv_url_jobhead
    } else {
        $global:dvurljobhead=''
    }

    if ($null -ne $env:dv_url_jobtask) {
        $global:dvurljobtask=$env:dv_url_jobtask
    } else {
        $global:dvurljobtask=''
    }

    if ($null -ne $env:dv_url_jobplanningline) {
        $global:dvurljobplanningline=$env:dv_url_jobplanningline
    } else {
        $global:dvurljobplanningline=''
    }

    if ($null -ne $env:dv_url_debitor) {
        $global:dvurldebitor=$env:dv_url_debitor
    } else {
        $global:dvurldebitor=''
    }

    if ($null -ne $env:dv_url_journal) {
        $global:dvurljournal=$env:dv_url_journal
    } else {
        $global:dvurljournal=''
    }

    if ($null -ne $env:dv_url_employee) {
        $global:dvurlemployee=$env:dv_url_employee
    } else {
        $global:dvurlemployee=''
    }

    if ($null -ne $env:DV_URL_STATISTIC) {
        $global:dvurlstatistic=$env:DV_URL_STATISTIC
    } else {
        $global:dvurlstatistic=''
    }

    if ($null -ne $env:DV_URL_STATISTICRUN) {
        $global:dvurlstatisticrun=$env:DV_URL_STATISTICRUN
    } else {
        $global:dvurlstatisticrun=''
    }

    if ($null -ne $env:BLOB_STORAGE_URI) {
        $global:blobstorageuri=$env:BLOB_STORAGE_URI
    } else {
        $global:blobstorageuri=''
    }

    if ($null -ne $env:CACHE_CONTAINER_NAME) {
        $global:cachecontainername=$env:CACHE_CONTAINER_NAME
    } else {
        $global:cachecontainername=''
    }

    if ($null -ne $env:AD_SERVER_NAME) {
        $global:adservername=$env:AD_SERVER_NAME
    } else {
        $global:adservername=''
    }

    if ($null -ne $env:AD_SERVER_PORT) {
        $global:adserverport=$env:AD_SERVER_PORT
    } else {
        $global:adserverport=''
    }

    if ($null -ne $env:AD_USERNAME_KVSECRETNAME) {
        $global:adusernamekvsecretname=$env:AD_USERNAME_KVSECRETNAME
    } else {
        $global:adusernamekvsecretname=''
    }

    if ($null -ne $env:AD_USERPASSWORD_KVSECRETNAME) {
        $global:aduserpasswordkvsecretname=$env:AD_USERPASSWORD_KVSECRETNAME
    } else {
        $global:aduserpasswordkvsecretname=''
    }

    if ($null -ne $env:AD_USEROU_PATH) {
        $global:aduseroupath=$env:AD_USEROU_PATH
    } else {
        $global:aduseroupath=''
    }

    if ($null -ne $env:AD_GROUPOU_PATH) {
        $global:adgroupoupath=$env:AD_GROUPOU_PATH
    } else {
        $global:adgroupoupath=''
    }

    if ($null -ne $env:AD_ASSIGNMENTGROUP_PREFIX) {
        $global:adassignmentgroupprefix=$env:AD_ASSIGNMENTGROUP_PREFIX
    } else {
        $global:adassignmentgroupprefix=''
    }




    
}
function Get-wupBCAuthHeader() {
    param()
    try {
        $r=Get-wupVaultSecret -secretName $global:bcspkvsecretname -vaultUrl $global:vaultUrl
        if ($r.Success) {
            $secretValue=$r.Value.Value
            $headers=@{
                "Content-Type"="application/x-www-form-urlencoded"
            }
            $tokenUrl="https://login.microsoftonline.com/$($global:tenantid)/oauth2/v2.0/token"
            $body="grant_type=client_credentials&client_id=$global:bcspclientid&scope=https://api.businesscentral.dynamics.com/.default&client_secret=$($secretValue)"
            $response=Invoke-WebRequest -Uri $tokenUrl -Body $body -Method Post -Headers $headers -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
            #$response=Invoke-widWebRequest -Uri $tokenUrl -Body $body -Method Post -Headers $headers -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
            $token=$response.Content | convertfrom-json | select -ExpandProperty access_token
            $bcHeader=@{
                "Authorization"="Bearer $token"
            }
            $r=New-Result -success $true -message "Successfully retrieved authentication header for BC" -value $bcHeader -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Error retreieving authentication header for BC" -logLevel Error -exception $_.exception
    }
    $r
}
function Get-wupSnowAuthHeader() {
    param(
        [switch]$adminToken
    )
    try {
        $secretName=$global:snowtokenkvsecretname
        if ($adminToken) {
            $secretName=$global:snowadmintokenkvsecretname
        }
        $r=Get-wupVaultSecret -secretName $secretName -vaultUrl $global:vaultUrl
        if ($r.Success) {
            $secretValue=$r.Value.Value
            $snowHeader=@{
                "Authorization"="Basic $secretValue"
                "Content-type"="application/json"
                "Accept"="application/json"
            }
            $r=New-Result -success $true -message "Successfully retrieved authentication header for SNOW" -value $snowHeader -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Error retreieving authentication header for SNOW" -logLevel Error -exception $_.exception
    }
    $r
}
function Get-wupDVAuthHeader() {
    param()
    try {
        $r=Get-AuthHeader -resourceURI $global:dvEnvironmentUrl
        if ($r.Success) {
            $dvHeader=$r.value
            $r=New-Result -success $true -message "Successfully retrieved authentication header for DV" -value $dvHeader -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Error retreieving authentication header for BC" -logLevel Error -exception $_.exception
    }
    $r
}
function Get-wupAuthHeader() {
    param(
        $type
    )
    $r=$(Invoke-Command $([ScriptBlock]::Create("Get-wup$($type)AuthHeader")))
    $r
}
function _Invoke-wupWebRequest() {
    param(
        $uri,
        $headers,
        $body=$null,
        $method,
        $contenttype="application/json",
        [switch]$UseBasicParsing,
        $maxretries=3,
        $retryDelayMS=1000
    )
    $response=$null
    $ex=$null
    $retries=0
    while ($retries -lt $maxretries) {
        try {
            if ($null -eq $body) {
                $response=Invoke-WebRequest -Uri $uri -Headers $headers -Method $method -UseBasicParsing
            } else {
                $response=Invoke-WebRequest -Uri $uri -Headers $headers -Method $method -Body $body -UseBasicParsing
            }
            $retries=$maxretries
        } catch {
            $ex=$_
            $retries+=1
            if ($retries -lt $maxretries) {
                Start-Sleep -Milliseconds ($retryDelayMS * $retries)
            }
        }
    }
    if ($null -ne $response) {
        $response
    } else {
        #$ex
        throw $ex.Exception
    }
}
function _Invoke-wupRestMethod() {
    param(
        $uri,
        $headers,
        $body=$null,
        $method,
        $contenttype="application/json",
        [switch]$UseBasicParsing,
        $maxretries=3,
        $retryDelayMS=1000
    )
    $response=$null
    $ex=$null
    $retries=0
    while ($retries -lt $maxretries) {
        try {
            if ($null -eq $body) {
                $response=Invoke-RestMethod -Uri $uri -Headers $headers -Method $method -UseBasicParsing
            } else {
                $response=Invoke-RestMethod -Uri $uri -Headers $headers -Method $method -Body $body -UseBasicParsing
            }
            $retries=$maxretries
        } catch {
            $ex=$_
            $retries+=1
            if ($retries -lt $maxretries) {
                Start-Sleep -Milliseconds ($retryDelayMS * $retries)
            }
        }
    }
    if ($null -ne $response) {
        $response
    } else {
        #$ex
        throw $ex.Exception
    }
}
function Get-wupBCData() {
    param(
        $bcHeader,
        $url,
        $filter=""
    )
    try {
        $uri=$url
        if ($filter.length -gt 0) {
            $uri+="?`$filter=$filter"
        }
        $response=Invoke-WebRequest -Uri $uri -Headers $bcHeader -Method Get -UseBasicParsing
        #$response=invoke-widWebRequest -uri $uri -headers $bcHeader -method Get -UseBasicParsing
        $records=$response.content | convertfrom-json | select -ExpandProperty value
        $r=New-Result -success $true -message "Successfully retrieved records from bc [$url]" -value $records -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error retrieving data from bc [$url]" -exception $_.exception -logLevel Error
    }
    $r
}
function Get-wupDVData() {
    param(
        $dvHeader,
        $url,
        $filter=""
    )
    try {
        $uri=$url
        if ($filter.length -gt 0) {
            $uri+="?`$filter=$filter"
        }
        $ht=[hashtable]@{}
        $dvHeader.GetEnumerator() | %{if ($_.name -in @("Authorization","Content-Type")) {$ht[$_.key]=$dvHeader[$_.key]}}
        $ht+=[hashtable]@{
            "OData-MaxVersion"="4.0"
            "OData-Version"="4.0"
            "Prefer"="odata.maxpagesize=100"
        }
        $dvHeader=$ht
        $data=@()
        $r=$null
        try {
            while ($null -ne $uri) {
                try {
                    $response=Invoke-RestMethod -Headers $dvHeader -Uri $uri  -Method get -UseBasicParsing
                    #$response=invoke-widRestMethod -Headers $dvHeader -Uri $uri  -Method get -UseBasicParsing
                    $data+=$response.value
                    $uri=$response.'@odata.nextLink'
                } catch {
                    $uri=$null
                    $r=New-Result -success $false -message "Error retreiving records from table $tableName" -exception $_.Exception
                }
            }
            if ($null -eq $r) {
                $r=New-Result -success $true -message "Successfully retrieved $($data.count) records from table $tableName" -value $data -logLevel Information
            }
        } catch {
            $r=New-Result -success $false -message "Error retreiving records from table $tableName" -exception $_.Exception
        }
    } catch {
        $r=New-Result -success $false -message "Error retrieving data from dv [$url]" -exception $_.exception -logLevel Error
    }
    $r
}
function Get-wupSNOWData() {
    param(
        $snowHeader,
        $url,
        $filter=""
    )
    try {
        if ($filter.length -gt 0) {
            $url+="?$filter"
        }
        $data=@()
        $response=Invoke-RestMethod -Headers $snowHeader -Uri $url -Method get -UseBasicParsing
        $data+=$response | select -expandproperty result
        $r=New-Result -success $true -message "Successfully retrieved $($data.count) records from url $[$url]" -value $data -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error retrieving data from snow [$url]" -exception $_.exception -logLevel Error
    }
    $r
}
function Get-wupData() {
    param(
        $syncJob
    )
    $r=Get-wupAuthHeader -type $syncJob.sourcetype | Write-Result
    if ($r.Success) {
        $header=$r.Value
        $url=$syncJob._sourceUrl
        $filter=$syncJob.dbfilter
        $r=Invoke-Command -ScriptBlock  ($([ScriptBlock]::Create("param(`$header,`$url,`$filter) Get-wup$($syncJob.sourcetype)Data -$($syncJob.sourcetype)header `$header -url `$url -filter `$filter"))) -ArgumentList @($header,$url,$filter)
    }
    if ($r.Success) {
        $data=$r.Value
        if ($syncJob.psFilter -ne "" -and $syncJob.psFilter -ne $null) {
            $psFilter=$([ScriptBlock]::Create($syncJob.psFilter))
            $data=$data | ? $psFilter
        }
        if ($syncJob._syncType -eq "delta") {
            $sdf=$syncJob.deltaFilter

            if ($null -eq $syncJob.lastDeltaSyncAt) {
                $sdf=$sdf.replace("###lastrunat###","1.1.0001")
            } else {
                $sdf=$sdf.replace("###lastrunat###",($syncJob.lastDeltaSyncAt).tostring("s"))
            }
            $deltaFilter=$([ScriptBlock]::Create($sdf))
            $data=$data | ? $deltaFilter
            <#
            if ($sdf -eq "jobTasks") {                
                $ids=$syncjob._previousJob._sourcedata | select @{"name"="id";"expression"={"$($_.jobno)-$($_.jobtaskno)"}} | select -Unique -ExpandProperty id
                $data=$data | ? {"$($_.jobno)-$($_.jobtaskno)" -in $ids}
            } else {
                if ($null -eq $syncJob.lastDeltaSyncAt) {
                    $sdf=$sdf.replace("###lastrunat###","1.1.0001")
                } else {
                    $sdf=$sdf.replace("###lastrunat###",($syncJob.lastDeltaSyncAt).tostring("s"))
                }
                $deltaFilter=$([ScriptBlock]::Create($sdf))
                $data=$data | ? $deltaFilter
            }
            #>
        }
        $r=New-Result -success $true -message "Successfully loaded source data from [$($syncJob.sourcetype)]: $($data.length) records" -value $data -logLevel Information
    }
    $r
}
function Get-wupVaultSecret() {
    param(
        $secretName,
        $vaultUrl=$global:vaultUrl
    )
    $r=Get-AccessToken -resourceURI $Global:vaultAuthenticationUrl
    if ($r.Success) {
        $token=$r.Value
        $r=Get-AuthHeader -resourceURI $Global:vaultAuthenticationUrl -accessToken $token    
    }
    if ($r.Success) {
        $authHeader=$r.Value
        $url="$($vaultUrl)secrets/$($secretName)?api-version=7.4"
        try {
            $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method GET -UseBasicParsing
            #$response=invoke-widWebRequest -Uri $url -Headers $authHeader -Method GET -UseBasicParsing
            $secretValue=$($response.content | convertfrom-json) # | select -ExpandProperty value
            $r=New-Result -success $true -message "Successfully retrieved vault secret $($secretName)" -value $secretValue -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error retrieving vault secret $($secretName) $($_.exception.Message)" -exception $_.exception -logLevel Error -value $(New-httpResponse -statusCode BadRequest -body "Error getting vault secret $($_.exception.message)")
        }
    }
    $r
}
function Get-wupVaultSecrets() {
    param(
        $vaultUrl=$global:vaultUrl
    )
    $r=Get-AccessToken -resourceURI $Global:vaultAuthenticationUrl
    if ($r.Success) {
        $token=$r.Value
        $r=Get-AuthHeader -resourceURI $Global:vaultAuthenticationUrl -accessToken $token    
    }
    if ($r.Success) {
        $authHeader=$r.Value
        $url="$($vaultUrl)secrets?maxresults=25&api-version=7.4"
        $secrets=@()
        try {
            while ($null -ne $url) {
                $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method GET -UseBasicParsing
                #$response=invoke-widWebRequest -Uri $url -Headers $authHeader -Method GET -UseBasicParsing
                $result=$($response.content | convertfrom-json)
                $url=$result.nextLink
                $secrets+=$($result | select -ExpandProperty value)
            }
            $r=New-Result -success $true -message "Successfully retrieved vault secrets" -value $secrets -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error retrieving vault secrets $($_.exception.Message)" -exception $_.exception -logLevel Error
        }
    }
    $r
} 
function Set-wupVaultSecret() {
    param(
        $secretName,
        $secretValue,
        $vaultUrl=$global:vaultUrl,
        $attributes=$null
    )
    $r=Get-AccessToken -resourceURI $Global:vaultAuthenticationUrl
    if ($r.Success) {
        $token=$r.Value
        $r=Get-AuthHeader -resourceURI $Global:vaultAuthenticationUrl -accessToken $token    
    }
    if ($r.Success) {
        $authHeader=$r.Value
        $body=[PSCustomObject]@{
            value=$secretValue
        }
        if ($null -ne $attributes) {
            $body | Add-Member -MemberType NoteProperty -Name "attributes" -Value $attributes
        }
        $body=$body | convertto-json
        $url="$($vaultUrl)secrets/$($secretName)?api-version=7.4"
        try {
            $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method PUT -Body $body -UseBasicParsing
            #$response=invoke-widWebRequest -Uri $url -Headers $authHeader -Method PUT -Body $body -UseBasicParsing
            $secretValue=$($response.content | convertfrom-json) | select -ExpandProperty value
            $r=New-Result -success $true -message "Successfully set vault secret $($secretName)" -value $secretValue -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error setting vault secret $($secretName) $($_.exception.Message)" -exception $_.exception -logLevel Error -value $(New-httpResponse -statusCode BadRequest -body "Error setting vault secret $($_.exception.message)")
        }
    }
    $r    
}
function Get-wupVaultSecretBackup() {
    param(
        $secretName,
        $vaultUrl=$global:vaultUrl
    )
    $r=Get-AccessToken -resourceURI $Global:vaultAuthenticationUrl
    if ($r.Success) {
        $token=$r.Value
        $r=Get-AuthHeader -resourceURI $Global:vaultAuthenticationUrl -accessToken $token    
    }
    if ($r.Success) {
        $authHeader=$r.Value
        $url="$($vaultUrl)secrets/$($secretName)/backup?api-version=7.4"
        try {
            $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method POST -Body $body -UseBasicParsing
            #$response=invoke-widWebRequest -Uri $url -Headers $authHeader -Method POST -Body $body -UseBasicParsing
            $secretBackupValue=$($response.content | convertfrom-json) | select -ExpandProperty value
            $r=New-Result -success $true -message "Successfully created vault secret backup for $($secretName)" -value $secretBackupValue -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error creating vault secret backup for $($secretName) $($_.exception.Message)" -exception $_.exception -logLevel Error
        }
    }
    $r 
}
function Get-wupApiSchema() {
    param(
        [switch]$doNotSetGlobalVariable
    )
    try {
        $r=Get-AuthHeader -resourceURI $global:tablestorageuri -additionalHeaderAttributes @{'Accept' = 'application/json;odata=nometadata';'x-ms-version'='2017-11-09'}
        if ($r.Success) {
            $authHeader=$r.Value
            $uri="$($global:tablestorageuri)$($global:ApiSchemaTableName)()"
            $response=Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Get
            #$response=invoke-widRestMethod -Uri $uri -Headers $authHeader -Method Get
            $apiSchema=$response.value
            $apiSchema | %{
                $schemaLine=$_
                if ($schemaLine.dvattname -eq 'default') {
                    $schemaLine.dvattname="$($global:dvEnvironmentPublisherPrefix)_$($schemaLine.bcattname)".ToLower()
                } else {
                    $schemaLine.dvattname=$schemaLine.dvattname.replace('###prefix###',"$($global:dvEnvironmentPublisherPrefix)_".ToLower())
                }
                if ($null -ne $schemaLine.attributes -and $_.attributes -gt "") {
                    $atts=$schemaLine.attributes | ConvertFrom-Json
                    $atts.psobject.properties | ? {$null -ne $_} | %{
                        $schemaLine | Add-Member -MemberType NoteProperty -Name $_.name -Value $_.value -force
                    }
                }
            }
            $uri="$($global:tablestorageuri)$($global:syncjobtablename)()"
            $response=Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Get
            #$response=invoke-widRestMethod -Uri $uri -Headers $authHeader -Method Get
            $syncJobSchema=$response.value
            $syncJobSchema | % {
                $jobDef=$_
                $jobDef.psobject.properties | ? {$_.name -like "*at"} | %{
                    if ($_.value -eq $null -or $_.value -eq "") {
                        $jobDef."$($_.name)"=$null
                    } else {
                        $jobDef."$($_.name)"=$(get-date $_.value | convertto-json | convertfrom-json) #make same as when loaded from queue/blob
                    }
                }
            }
            $schema=[PSCustomObject]@{
                apischema=$apiSchema
                syncJobs=$syncJobSchema
            }
            if (!($doNotSetGlobalVariable)) {$global:schema=$schema}
            $r=New-Result -success $true -message "Successfully loaded schema" -value $schema -logLevel Information    
        }
    } catch {
        if ($_.Exception.response.statuscode -eq "NotFound") {
            $r=New-Result -success $false -message "No apischema data found" -exception $_.Exception -logLevel Warning -value $(New-httpResponse -statusCode InternalServerError -body "Error loading schema")
        } else {
            $r=New-Result -success $false -message "Error retrieving api schema" -exception $_.Exception -logLevel Error -value $(New-httpResponse -statusCode InternalServerError -body "Error loading schema")
        }
    }
    $r
}
function Get-wupEmployeeDepartmentData() {
    param(
        [switch]$doNotSetGlobalVariable
    )
    try {
        $r=Get-AuthHeader -resourceURI $global:tablestorageuri -additionalHeaderAttributes @{'Accept' = 'application/json;odata=nometadata';'x-ms-version'='2017-11-09'}
        if ($r.Success) {
            $authHeader=$r.Value
            $uri="$($global:tablestorageuri)$($global:departmenttablename)()"
            $response=Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Get
            #$response=invoke-widRestMethod -Uri $uri -Headers $authHeader -Method Get
            $departmentData=$response.value
            if (!($doNotSetGlobalVariable)) {$global:departmentData=$departmentData}
            $r=New-Result -success $true -message "Successfully loaded employee department data" -value $departmentData -logLevel Information    
        }
    } catch {
        if ($_.Exception.response.statuscode -eq "NotFound") {
            $r=New-Result -success $false -message "No employee department data found" -exception $_.Exception -logLevel Warning -value $(New-httpResponse -statusCode InternalServerError -body "Error loading employee department data")
        } else {
            $r=New-Result -success $false -message "Error retrieving employee department data" -exception $_.Exception -logLevel Error -value $(New-httpResponse -statusCode InternalServerError -body "Error loading employee department data")
        }
    }
    $r
}
function Convert-wupBody() {
    param(
        $source,
        $sourceType,
        $recordType,
        $destinationType
    )
    if ($($source.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -eq "Array") {
        $destinationBodies=@()
        $source | ? {$null -ne $_} | %{
            $destinationBodies+=Convert-wupBody -source $_ -sourceType $sourceType -recordType $recordType -destinationType $destinationType
        }
        ,$destinationBodies
    } else {
        $fields=$global:schema.apischema | ? {$_.entity -eq $recordType}
        $destinationBody=[PSCustomObject]@{}
        $fields | ? {$null -ne $_ -and $_."$($destinationType)attname" -notlike '$*' -and $_."$($destinationType)attname" -ne ""} | sort "$($destinationType)attname" | %{
            $field=$_
            if ($null -ne $field."$($destinationType)attname") {
                #if ($source.$($field."$($sourceType)attname") -like "$*") {
                if ($($field."$($sourceType)attname") -like "$*") {
                    $v=$(Invoke-Command $([ScriptBlock]::Create($($field."$($sourceType)attname"))))
                } else {
                    $v=$source.$($field."$($sourceType)attname")
                }
                $destinationBody | Add-Member -MemberType NoteProperty -Name $field."$($destinationType)attname" -Value $v -Force
            }
        }
        ,[array]@($destinationBody)
    }
}
function Set-wupSNOWData() {
    param(
        $snowHeader,
        $url,
        $data
    )
    try {
        if ($($data.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -eq "Array") {
            $uri="$($url)/insertMultiple"
            $data=[PSCustomObject]@{
                records = $data
            }
        } else {
            $uri=$url
        }
        $response=Invoke-WebRequest -Uri $uri -Headers $snowHeader -Method Post -Body $($data | ConvertTo-Json -Depth 100) -UseBasicParsing -ContentType "application/json; charset=utf-8"
        #$response=invoke-widWebRequest -Uri $uri -Headers $snowHeader -Method Post -Body $($data | ConvertTo-Json -Depth 100) -UseBasicParsing -ContentType "application/json; charset=utf-8"
        $r=New-Result -success $true -message "Successfully posted records to snow [$url]" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error posting data to snow [$url]" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-wupDVData() {
    param(
        $dvHeader,
        $url,
        $recordType,
        $data
    )
    try {
        $ht=[hashtable]@{}
        $dvHeader.GetEnumerator() | %{if ($_.name -in @("Authorization","Content-Type")) {$ht[$_.key]=$dvHeader[$_.key]}}
        $ht+=[hashtable]@{
            "OData-MaxVersion"="4.0"
            "OData-Version"="4.0"
            "Accept"="application/json"
        }
        $dvHeader=$ht
        if ($($data.gettype() | select -ExpandProperty basetype | select -ExpandProperty name) -eq "Array") {
            $data=$data
        } else {
            $data=@($data)
        }
        $pk=$global:schema.apischema | ? {$_.entity -eq $recordType -and $_.isprimarykey -eq 1} | select -ExpandProperty dvattname
        $r=new-result -success $true -message "Dummy result for boostraping the function"
        for ($i=0;$i -lt $data.Length;$i+=1000) {
            $dvBatch=New-DVBatch
            $batchData=$data[$i..($i+999)]
            $batchData | %{
                $item=$_
                if ($r.Success) {
                    $uri="$($url)($($pk)='$($item."$($pk)")')"
                    $body=$item | ConvertTo-Json -Depth 100 -Compress
                    $r=$dvBatch.AddRequest($uri,"PATCH","application/json; charset=utf-8; type=entry",$body,$false)
                }
            }
            if ($r.Success) {
                $r=$dvBatch.run($global:dvEnvironmentUrl,$null,$dvHeader)
            }
        }
        if ($r.Success) {
            $r=New-Result -success $true -message "Successfully posted records to dv [$url]" -value $response -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Error posting data to dv [$url]" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-wupBCJournalRecord() {
    param(
        $bcHeader,
        [ValidateSet('jobworksheet','jobLedger')]$journalRecordType,
        $record,
        $existingRecord=$null,
        $primaryKeyName="systemid"
    )
    try {
        $uri=$(Invoke-Command([scriptblock]::Create("`$global:bcurl$($journalRecordType)")))
        if ($null -eq $existingRecord) {
            $header=$bcHeader | Merge-HeaderAttributes -additionalHeaderAttributes $([hashtable]@{})
            $method="POST"
            $messageSuccess="Successfully added bc journal record [$($journalRecordType)]"
            $messageError="Error adding bc journal record [$($journalRecordType)]"
        } else {
            $uri="$($uri)($($existingRecord.$($primaryKeyName)))"
            $header=$bcHeader | Merge-HeaderAttributes -additionalHeaderAttributes $([hashtable]@{
                "if-match"=$($existingRecord.'@odata.etag')
            })
            $method="PATCH"
            $messageSuccess="Successfully set bc journal record [$($journalRecordType), $($primaryKeyName): $($existingRecord.$($primaryKeyName))]"
            $messageError="Error setting bc journal record [$($journalRecordType), $($primaryKeyName): $($existingRecord.$($primaryKeyName))]"
        }
        $recordJson=$record | ConvertTo-Json
        $response=Invoke-WebRequest -Uri $uri -Body $recordJson -Method $method -Headers $header -ContentType "application/json; charset=utf-8" -UseBasicParsing
        #$response=invoke-widWebRequest -Uri $uri -Body $recordJson -Method $method -Headers $header -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message $messageSuccess -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message $messageError -exception $_.exception -logLevel Error
    }
    $r
}
function Get-wupBCJournalStornoRecord() {
    param(
        $bcLedgerRecord
    )
    $stornoRecord=[PSCustomObject]@{}
    $bcLedgerRecord.psobject.properties | %{
        $stornoRecord | Add-Member -MemberType NoteProperty -Name $_.name -value $_.value -Force
    }
    $stornoRecord.quantity=(-1)*$stornoRecord.quantity
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "WAGStorno" -value $true -Force
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "journalTemplateName" -value "PROJEKT" -Force
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "journalBatchName" -value "Z_`$NOW`$" -Force
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "unitOfMeasureCode" -value "STD" -Force
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "LineType" -value "Billable" -Force    
    $select=[scriptblock]::Create("`$stornorecord | Select $(($global:schema.apischema | ? {$_.entity -eq "journal"} | select -ExpandProperty bcattname) -join ',')")
    $stornoRecord=invoke-command($select)
    $stornoRecord | Add-Member -MemberType NoteProperty -Name "shortcutDimension2Code" -Value $bcLedgerRecord.globalDimension2Code
    $stornoRecord
}
function Get-wupBCJournalPatchRecord() {
    param(
        $record
    )
    $patchRecord=[PSCustomObject]@{}
    $record.psobject.properties | %{
        $patchRecord | Add-Member -MemberType NoteProperty -Name $_.name -value $_.value -Force
    }
    $select=[scriptblock]::Create("`$patchrecord | Select $(($global:schema.apischema | ? {$_.entity -eq "journal" -and $null -eq $_.skiponbcpatch} | select -ExpandProperty bcattname) -join ',')")
    $patchRecord=invoke-command($select)
    $patchRecord
}
function Set-wupBCURLJobworksheet() {
    param(
        $bcHeader
    )
    try {
        $response=Invoke-WebRequest -Uri $global:bcurljournal -Headers $bcHeader -Method Get -UseBasicParsing
        #$response=invoke-widWebRequest -Uri $global:bcurljournal -Headers $bcHeader -Method Get -UseBasicParsing
        $journalId=($response.Content | convertfrom-json | select -ExpandProperty value) | ? {$_.code -like 'Z_*NOW*'} | select -ExpandProperty id
        $global:bcurljobworksheet=$($global:bcurljobworksheet).Replace("###journalid###",$journalId)
        $r=New-Result -success $true -message "Successfully set BC jobWorkSheet-url" -value $global:bcurljobworksheet -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting BC jobWorkSheet-url" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-wupBCJournalData() {
    param(
        $record,
        $bcHeader
    )
    $stornoRecord=$null
    $r=Set-wupBCURLJobworksheet -bcHeader $bcHeader
    if ($r.Success) {
        $r=Get-wupBCData -bcHeader $bcHeader -url $global:bcurljobworksheet -filter "(wagGUIDNOW eq '$($record.WAGGUIDNOW)')"
    }
    if ($r.Success) {
        $bcJournalData=$r.Value | ? {$_.WAGStorno -eq $false}
        if ($null -eq $bcJournalData) {
            $r=Get-wupBCData -bcHeader $bcHeader -url $global:bcurljobledger -filter "(wagGUIDNOW eq '$($record.WAGGUIDNOW)')"
            if ($r.Success) {
                $bcLedgerData=$r.Value | ? {$_.WAGStorno -eq $false}
                if ($null -ne $bcLedgerData) {
                    New-Result -success $true -message "Existing record found in ledger [$($record.WAGGUIDNOW)]; adding storno" -logLevel Information | Write-Result -NoPassThru
                    #insert storno into journal
                    $stornoRecord=Get-wupBCJournalStornoRecord -bcLedgerRecord $bcLedgerData[0]
                    $r=Set-wupBCJournalRecord -bcHeader $bcHeader -journalRecordType jobworksheet -record $stornoRecord | Write-Result
                    if ($r.Success) {
                        #set ledger record to storno
                        $ledgerStornoRecord=[PSCustomObject]@{
                            wagstorno=$true
                        }
                        $r=Set-wupBCJournalRecord -bcHeader $bcHeader -journalRecordType jobLedger -record $ledgerStornoRecord -existingRecord $bcLedgerData[0] | Write-Result
                    }
                }                
                if ($r.Success) {
                    #insert new record into journal
                    New-Result -success $true -message "Adding new record to journal [$($record.WAGGUIDNOW)]" -logLevel Information | Write-Result -NoPassThru
                    $r=Set-wupBCJournalRecord -bcHeader $bcHeader -journalRecordType jobworksheet -record $record | Write-Result
                }
            }
        } else {
            New-Result -success $true -message "Existing record found in journal [$($record.WAGGUIDNOW)]; patching" -logLevel Information | Write-Result -NoPassThru
            #patch existing journal record
            $patchRecord=Get-wupBCJournalPatchRecord -record $record
            $r=Set-wupBCJournalRecord -bcHeader $bcHeader -journalRecordType jobworksheet -record $patchRecord -existingRecord $bcJournalData[0] | Write-Result
        }
    }
    if ($r.Success) {
        $r=New-Result -success $true -message "Successfully set bc journal data" -value $stornoRecord -logLevel Information
    }
    $r
}
function Set-wupSyncJob() {
    param(
        $syncJob,
        [switch]$queued,
        [switch]$finished
    )
    $r=Get-AuthHeader -resourceURI $global:tablestorageuri -additionalHeaderAttributes @{'Accept' = 'application/json;odata=nometadata';'x-ms-version'='2017-11-09'}
    if ($r.Success) {
        $authHeader=$r.Value
        try {
            $uri="$($global:tablestorageuri)$($global:syncjobtablename)(PartitionKey='$($syncJob.partitionKey)',RowKey='$($syncJob.rowKey)')"
            $body=[PSCustomObject]@{}
            $syncjob.psobject.properties | ? {$_.name -notlike "_*" -and $_.name -ne "rowkey" -and $_.name -ne "Partitionkey" -and $_.name -ne "Timestamp"} | %{
                if ($_.name -like "*at") {
                    if ($_.value -eq $null) {
                        $body | Add-Member -MemberType NoteProperty -Name $_.name.tolower() -Value ""
                    } else {
                        #$body | Add-Member -MemberType NoteProperty -Name $_.name.tolower() -Value (get-date ($syncjob.$($_.name) | select -ExpandProperty value)).tostring("s") -Force
                        $body | Add-Member -MemberType NoteProperty -Name $_.name.tolower() -Value (get-date ($syncjob.$($_.name))).tostring("s") -Force
                    }
                } else {
                    $body | Add-Member -MemberType NoteProperty -Name $_.name.tolower() -Value $_.value
                }
            }

            if ($queued) {
                $body | Add-Member -MemberType NoteProperty -Name "queuedat" -Value $((Get-Date).ToString("s")) -Force
            }

            if ($finished) {
                $body | Add-Member -MemberType NoteProperty -Name "queuedat" -Value "" -Force
                switch ($syncJob._syncType) {
                    "full" {
                        $body | Add-Member -MemberType NoteProperty -Name "lastfullsyncat" -Value $((Get-Date).ToString("s")) -Force
                        $body | Add-Member -MemberType NoteProperty -Name "lastdeltasyncat" -Value $((Get-Date).ToString("s")) -Force
                        break
                    }
                    "delta" {
                        $body | Add-Member -MemberType NoteProperty -Name "lastdeltasyncat" -Value $((Get-Date).ToString("s")) -Force
                        break
                    }
                    Default {}
                }
            }
            $jsonBody=$body | ConvertTo-Json
            $response=Invoke-WebRequest -Uri $uri -Headers $authHeader -Method Put -Body $jsonBody
            #$response=invoke-widWebRequest -Uri $uri -Headers $authHeader -Method Put -Body $jsonBody
            $r=New-Result -success $true -message "Successfully added/updated syncJob with partitionkey $($syncJob.partitionKey) and rowkey $($syncJob.rowKey)" -value $response -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error adding/updating syncJob with partitionkey $($syncJob.partitionKey) and rowkey $($syncJob.rowKey)" -exception $_.Exception -logLevel Error
        }        
    }
    $r
}
function Set-wupBlobData() {
    param(
        $blobData
    )
    $r=Get-AccessToken -resourceURI $global:blobstorageuri
    if ($r.Success) {
        try {
            $blobToken=$r.Value
            $blobID=[Guid]::NewGuid() | select -ExpandProperty guid
            #$blobData=$data | convertto-json -Depth 100 -Compress
            $headers=@{
                "Authorization"="Bearer $blobToken"
                "x-ms-version"="2023-08-03"
                "x-ms-date"="$(([System.DateTime]::UtcNow).tostring('ddd, dd MMM yyyy HH:mm:ss')) GMT"
                "x-ms-blob-type"="BlockBlob"
                #"Content-Type"="application/json"
                #"Content-Length"=$blobdata.length
            }
            $uri="$($global:blobstorageuri)$($global:cachecontainername)/$($blobID)"
            $response=invoke-webrequest -Uri $uri -Headers $headers -Body $blobData -Method Put -UseBasicParsing -ContentType "application/json; charset=utf-8"
            #$response=invoke-widWebRequest -Uri $uri -Headers $headers -Body $blobData -Method Put -UseBasicParsing -ContentType "application/json; charset=utf-8"
            $r=New-Result -success $true -message "Successfully set storage blob [$($blobID)]" -value "$blobID"
        } catch {
            $r=New-Result -success $false -message "Error setting storage blob" -exception $_.exception -logLevel Error
        }
    }
    $r
}
function get-wupBlobData() {
    param(
        $blobID
    )
    $r=Get-AccessToken -resourceURI $global:blobstorageuri
    if ($r.Success) {
        try {
            $blobToken=$r.Value
            $headers=@{
                "Authorization"="Bearer $blobToken"
                "x-ms-version"="2023-08-03"
                "x-ms-date"="$(([System.DateTime]::UtcNow).tostring('ddd, dd MMM yyyy HH:mm:ss')) GMT"
                "x-ms-blob-type"="BlockBlob"
                "Content-Type"="application/json"
                "Content-Length"=$blobdata.length
            }
            $uri="$($global:blobstorageuri)$($global:cachecontainername)/$($blobID)"
            $response=invoke-webrequest -Uri $uri -Headers $headers -Method Get -UseBasicParsing
            #$response=invoke-widWebRequest -Uri $uri -Headers $headers -Method Get -UseBasicParsing
            $data=$response.content | convertfrom-json
            $r=New-Result -success $true -message "Successfully got storage blob [$($blobID)]" -value $data
        } catch {
            $r=New-Result -success $false -message "Error getting storage blob" -exception $_.exception -logLevel Error
        }
    }
    $r    
}
function Remove-wupBlobData() {
    param(
        $blobID
    )
    $r=Get-AccessToken -resourceURI $global:blobstorageuri
    if ($r.Success) {
        try {
            $blobToken=$r.Value
            $headers=@{
                "Authorization"="Bearer $blobToken"
                "x-ms-version"="2023-08-03"
                "x-ms-date"="$(([System.DateTime]::UtcNow).tostring('ddd, dd MMM yyyy HH:mm:ss')) GMT"
                "x-ms-blob-type"="BlockBlob"
                "Content-Type"="application/json"
                "Content-Length"=$blobdata.length
            }
            $uri="$($global:blobstorageuri)$($global:cachecontainername)/$($blobID)"
            $response=invoke-webrequest -Uri $uri -Headers $headers -Method Delete -UseBasicParsing
            #$response=invoke-widWebRequest -Uri $uri -Headers $headers -Method Delete -UseBasicParsing
            $r=New-Result -success $true -message "Successfully deleted storage blob [$($blobID)]" -value $blobID
        } catch {
            $r=New-Result -success $false -message "Error deleting storage blob" -exception $_.exception -logLevel Error
        }
    }
    $r
}
function Add-wupQueueMessage() {
    param(
        $queueMessage,
        $queueName        
    )

    if (($queueMessage.gettype() | select -ExpandProperty name) -eq "PSCustomObject") {
        $queueMessage=$queueMessage | ConvertTo-Json -Depth 100 -Compress    
    }
    $r=Set-wupBlobData -blobData $queueMessage | Write-Result
    if ($r.Success) {
        $blobID=$r.value
        $r=Get-AuthHeader -resourceURI $global:QueueStorageUri -additionalHeaderAttributes @{'Accept' = 'text/xml';'x-ms-version'='2017-11-09'} | Write-Result
    }
    if ($r.Success) {
        $authHeader=$r.Value
        $queueEntry=[PSCustomObject]@{
            blobID=$blobID
        } | ConvertTo-Json
        $queueEntry = [Text.Encoding]::UTF8.GetBytes($queueEntry)
        $queueEntry =[Convert]::ToBase64String($queueEntry)
        $body = "<QueueMessage><MessageText>$queueEntry</MessageText></QueueMessage>"
        $queueUri="$($global:queueStorageUri)$($queuename)/messages"
        try {
            $response=Invoke-WebRequest -Uri $queueUri -Headers $authHeader -Method Post -Body $body
            #$response=invoke-widWebRequest -Uri $queueUri -Headers $authHeader -Method Post -Body $body
            $r=New-Result -success $true -message "Successfully added message to queue [$($queueName)] [$($blobID)]" -value $blobID -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error adding message to queue" -exception $_.Exception -logLevel Error
        }
    }
    $r
}
function Get-wupQueueMessage() {
    param(
        $queueEntry
    )
    $blobID=$queueEntry.blobID
    $r=get-wupBlobData -blobID $blobID
    $r
}
function Remove-wupQueueMessage() {
    param(
        $queueEntry
    )
    $blobID=$queueEntry.blobID
    $r=Remove-wupBlobData -blobID $blobID
    $r
}
function Get-wupADServerSession() {
    param(
        $credential
    )
    try {
        $session=New-PSSession -UseSSL -ComputerName $global:adservername -Port $global:adserverport -Credential $credential -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)
        $r=New-Result -success $true -message "Successfully opened session to ADDS server [$($global:adservername)]" -value $session -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error opening session to ADDS server [$($global:adservername)]" -exception $_.exception -logLevel $Error
    }
    $r
}
function Invoke-wupADServerCommandEmployee() {
    param(
        $record,
        $session,
        $credential
    )
    try {
        $adSettings=[PSCustomObject]@{
            userOuPath=$global:aduseroupath
            groupOuPath=$global:adgroupoupath
            assignmentGroupPrefix=$global:adassignmentgroupprefix
        }

        $r=Invoke-Command -Session $session -ScriptBlock {

            param(
                $credential,
                $userrecord,
                $adsettings
            )
            function New-Result() {
                param(
                    [parameter(Mandatory=$true)][bool]$success,
                    [string]$message="",
                    [System.Exception]$exception=$null,
                    [System.Object]$value=$null,
                    [ValidateSet("Verbose","Information","Warning","Error")]$logLevel="Information"
                )
                if (($exception -ne $null) -and ($logLevel -eq "Information")) {$logLevel="Error"}
                [PSCustomObject]@{
                    Success=$success
                    Message=$message
                    Exception=$exception
                    Value=$value
                    LogLevel=$logLevel
                }
            }
            function Get-wupADUser() {
                try {
                    $mode=0
                    $adUser=Get-ADUser -Filter "samAccountName -eq '$($id)'" -Credential $credential
                    if ($null -eq $adUser) {
                        New-ADUser -Name $displayName -displayName $displayName -GivenName $firstName -Surname $name -EmailAddress $businessEMail -SamAccountName $id -UserPrincipalName $businessEMail -Path $userOuPath -Credential $credential | out-null
                        $adUser=Get-ADUser -Filter "samAccountName -eq '$($id)'" -Credential $credential
                        $mode=1
                    } else {
                        Set-ADUser -Identity $adUser -Givenname $firstName -Surname $name -displayName $displayName -EmailAddress $businessEMail -Credential $credential | Out-Null
                    }
                    Set-ADuser -Identity $adUser -EmployeeNumber $employeeNo -Department $departmentname -Credential $credential | Out-Null
                    $adUser | Add-Member -MemberType NoteProperty -Name "changeMode" -Value $mode -Force
                    $r=New-Result -success $true -message "Successfully $(if ($mode -eq 0) {'modified'} else {'created'}) ADDS user [$($id)]" -value $adUser -logLevel Information
                } catch {
                    $r=New-Result -success $false -message "Error $(if ($mode -eq 0) {'modifying'} else {'creating'}) ADDS user [$($id)]" -exception $_.exception -logLevel Error
                }
                $r    
            }
            function Get-wupADGroup() {
                param(
                    $groupDef
                )
                try {
                    $mode=0
                    $adGroup=Get-ADGroup -filter "name -eq '$($groupDef.groupName)'" -Credential $credential
                    if ($null -eq $adGroup) {
                        New-ADGroup -Name $groupDef.groupname -SamAccountName $groupDef.groupname -GroupCategory Security -GroupScope Global -DisplayName $groupDef.groupname -Path $groupoupath -Description $groupdef.description -Credential $credential | out-null
                        $adGroup=Get-ADGroup -filter "name -eq '$($groupDef.groupName)'" -Credential $credential
                        $mode=1
                    } else {
                        Set-ADGroup -Identity $adGroup -displayName $groupDef.groupname -description $groupdef.description -Credential $credential  | out-null
                    }
                    $adGroup | Add-Member -MemberType NoteProperty -Name "changeMode" -Value $mode -Force
                    $r=New-Result -success $true -message "Successfully $(if ($mode -eq 0) {'modified'} else {'created'}) ADDS group [$($groupdef.groupname)]" -value $adGroup -logLevel Information
                } catch {
                    $r=New-Result -success $false -message "Error $(if ($mode -eq 0) {'modifying'} else {'creating'}) ADDS group [$($groupdef.groupname)]" -exception $_.exception -logLevel Error
                }
                $r
            }
            function Set-wupADUserMemberships() {
                try {
                    Add-ADGroupMember -Identity $adGroup -Members $adUser.distinguishedName | out-null
                    $r=New-Result -success $true -message "Successfully set group memberships of ADDS user [$($id)] in ADDS group [$($adgroup.description)]" -value $adUser -logLevel Information
                } catch {
                    $r=New-Result -success $false -message "Error setting group memberships of ADDS user [$($id)]" -exception $_.exception -logLevel Error
                }
                $r    
            }
            
            $systemId=$userrecord.systemId                # 14dee64c-fd10-ee11-8f6e-6045bd29b593
            $employeeNo=$userrecord.employeeNo            # 468
            $name=$userrecord.name                        # Candan-Ince
            $firstName=$userrecord.firstName              # Sevinç
            $businessEMail=$userrecord.businessEMail      # sevinc.candan@wagner.ch
            $id=$userrecord.id                            # CANS
            $department=$userrecord.department            # 4150
            $transfertonow=$userrecord.transfertonow      # true
            $departmentName=$(if ($null -eq $userrecord.departmentname) {$userrecord.department} else {$userrecord.departmentname})
            $useroupath=$adsettings.userOuPath
            $groupoupath=$adsettings.groupOuPath
            $assignmentGroupPrefix=$adsettings.assignmentGroupPrefix
            $displayName="$($name) $($firstName)"
            
            $adGroupDefs=@()
            $userrecord.adds_assignment_groups.split(",") | %{
                $adGroupDefs+=[PSCustomObject]@{
                    groupName = "$($assignmentGroupPrefix)$($_)"
                    description=$_
                }
            }

            $r=Get-wupADUser
            if ($r.Success) {
                $adUser=$r.Value
            }
            if ($r.Success) {
                if ($transfertonow -eq $true) {
                    $adGroupDefs | % {
                        if ($r.Success) {
                            $r=Get-wupADGroup -groupDef $_
                        }
                        if ($r.Success) {
                            $adGroup=$r.Value
                            $r=Set-wupADUserMemberships
                        }
                    }
                }
            }
            if ($r.Success) {
                $r=New-Result -success $true -message "Successfully processed ADDS user [$($id), $($departmentName)]"
            }
            $r

        } -ArgumentList @($credential,$record,$adSettings)
    } catch {
        $r=New-Result -success $false -message "Unexpected error running remote ps script" -exception $_.exception -logLevel Error
    }
    $r
}
function Compare-wupDataDVSNOW() {
    param(        
        [Validateset("debitor","jobHead","jobTask","jobplanningline","journal")]$entityName,
        $dvIdFieldName="widup_systemid",
        $snowIdFieldName="u_bc_number",
        $compareDate=$null
    )
    try {
        $snowFilter=""
        $dvFilter=""
        if ($null -ne $compareDate) {
            $d=get-date $compareDate
            $ds="$($d.Year)-$($d.month)-$($d.day)"
            $snowFilter="sysparm_query=sys_created_onBETWEENjavascript:gs.dateGenerate('$($ds)','00:00:01')@javascript:gs.dateGenerate('$($ds)','23:59:59')"
            $dvFilter="createdon ge '$($ds) 00:00' and createdon le '$($ds) 23:59'"
        }
        $r=Get-wupSnowAuthHeader -adminToken | Write-Result
        if ($r.Success) {
            $snowHeader=$r.Value
            $r=Get-wupDVAuthHeader | Write-Result
        }
        if ($r.Success) {
            $dvHeader=$r.Value
            $r=Get-wupSNOWData -snowHeader $snowHeader -url $(Invoke-Command([scriptblock]::Create("`$global:snowtableurl$($entityName)"))) -filter $snowFilter | Write-Result
        }
        if ($r.Success) {
            $snowData=$r.Value
            $r=Get-wupDVData -dvHeader $dvHeader -url $(Invoke-Command([scriptblock]::Create("`$global:dvurl$($entityName)"))) -filter $dvFilter
        }
        if ($r.Success) {
            $dvData=$r.value
            $missingRecords=$dvData | ? {$_.$($dvIdFieldName) -notin $($snowData | select -expandproperty $($snowIdFieldName))}
            $extraRecords=$snowData | ? {$_.$($snowIdFieldName) -notin $($dvData | select -expandproperty $($dvIdFieldName))}
            $ok=($missingRecords.length -eq 0) -and ($extraRecords.length -eq 0)
            $diff=[PSCustomObject]@{
                entityName = $entityName
                compareDate=$compareDate
                dvRecords=$dvData
                snowRecords=$snowData
                numDVRecords=$($dvData.length)
                numSNOWRecords=$($snowData.length)
                missingRecords=$missingRecords
                extraRecords=$extraRecords
                ok=$ok
            }
            $r=new-result -success $true -message "Successfully compared records from snow and dv" -value $diff -logLevel Information
        }
    } catch {
        $r=new-result -success $false -message "Error comparing records from snow and dv" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-wupStatistics() {
    param(
        $dayOffset=0
    )
    try {
        $compareDate=$(Get-Date).AddDays($dayOffset)
        $did="$('{0:d8}' -f $compareDate.Year)-$('{0:d4}' -f $compareDate.Month)-$('{0:d4}' -f $compareDate.Day)"
        $dvdate="$($compareDate.Year)-$($compareDate.Month)-$($compareDate.Day)"
        $recs=@()
        $r=Compare-wupDataDVSNOW -entityname "debitor" -comparedate $compareDate
        $recs+=$r.value
        $r=Compare-wupDataDVSNOW -entityname "jobhead" -comparedate $compareDate
        $recs+=$r.value
        $r=Compare-wupDataDVSNOW -entityname "jobtask" -comparedate $compareDate
        $recs+=$r.value
        $r=Compare-wupDataDVSNOW -entityname "jobplanningline" -comparedate $compareDate
        $recs+=$r.value
        $r=Compare-wupDataDVSNOW -entityname "journal" -dvIdFieldName "widup_wagguidnow" -snowIdFieldName "sys_id" -comparedate $compareDate
        $recs+=$r.value

        $no_journalDiff=0
        $no_journalHour=0
        $journalRec=$recs | ? {$_.entityName -eq 'journal'}
        $journalRec.snowRecords | ? {$null -ne $_} | %{
            $snowRec=$_
            $dvRec=$journalRec.dvRecords | ? {$_.widup_wagguidnow -eq "$($snowRec.sys_id)"}
            if ($null -ne $dvRec) {
                $valid=$true
                $valid=$valid -and ([decimal]$snowRec.u_billable_amount_h -eq [decimal]$dvRec.widup_quantity)
                $valid=$valid -and ($(get-date $snowRec.u_card_date -Format "yyyy-MM-dd") -eq $(get-date $dvRec.widup_postingdate -format "yyyy-MM-dd"))
                if (!$valid) {
                    $no_journalDiff+=1
                } else {
                    $no_journalHour+=$snowRec.u_billable_amount_h
                }
            } else {
                $no_journalDiff+=1
            }
        }
        $body=[PSCustomObject]@{}
        $ok=$true
        @("debitor","jobhead","jobtask","jobplanningline","journal") | %{
            $entityName=$_
            $ok=$ok -and $($recs | ? {$_.entityName -eq $entityName} | select -ExpandProperty ok)
            $body | Add-Member -MemberType NoteProperty -Name "widup_nrs_$($entityName)" -Value $($recs | ? {$_.entityName -eq $entityName} | select -ExpandProperty numSnowRecords)
            $body | Add-Member -MemberType NoteProperty -Name "widup_nrd_$($entityName)" -Value $($recs | ? {$_.entityName -eq $entityName} | select -ExpandProperty numDvRecords)
        }
        $body | Add-Member -MemberType NoteProperty -Name "widup_nr_journaldiff" -Value $no_journalDiff
        $body | Add-Member -MemberType NoteProperty -Name "widup_nr_journalhour" -Value $no_journalHour
        $body | Add-Member -MemberType NoteProperty -Name "widup_dstring" -Value $did
        $body | Add-Member -MemberType NoteProperty -Name "widup_date" -Value $dvdate
        $body | Add-Member -MemberType NoteProperty -Name "widup_ok" -Value $ok
        
        $r=Get-AccessToken -resourceURI $global:dvEnvironmentUrl
        if ($r.Success) {
            $dvToken=$r.Value
            $r=Set-DvData -envUri $global:dvEnvironmentUrl -accessToken $dvToken -tableName "widup_statistics" -body $($body | ConvertTo-Json -Compress) -upsertQuery "widup_did='$did'"
        }
        if ($r.Success) {
            $r=New-Result -success $true -message "Successfully set widup statistics" -value $body -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Error setting widup statistics" -exception $_.exception -logLevel Error
    }
    $r
}
