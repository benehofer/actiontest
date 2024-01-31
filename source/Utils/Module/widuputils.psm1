#BEGIN Test functions
function Get-RandomWords() {
    param(
        $numberOfWords=1
    )
    $s=""
    $headers=@{
        "X-Api-Key"="vbNJEfNM+GlJgUb5hHrz5Q==2pDmnvj5GTBclWr3"
    }
    $response=Invoke-WebRequest -Uri "https://random-word-api.herokuapp.com/word?number=$numberofwords" -method Get -UseBasicParsing
    $s=$($response.content | convertfrom-json) -join " "
    $s
}
#END Test functions
#BEGIN Bootstrap functions
function Get-FunctionKeys() {
    param(

    )
    $functionKeys=[PSCustomObject]@{}
    @("snow","bc","system") | %{
        $section=$_
        $secretName="functionkey$($section)"
        $r=Get-wupVaultSecret -secretName $secretName
        if ($r.Success) {
            $key=$r.Value.value
        } else {
            $key=New-RandomString -numBytes 64
            $r=Set-wupVaultSecret -secretName $secretName -secretValue $key
        }
        if ($r.Success) {
            $functionKeys | Add-Member -MemberType NoteProperty -Name "$($section)Key" -Value $($r.Value)
        }
    }
    $functionKeys    
}
function Backup-VaultSecrets() {
    param(
        $envName,
        $variableDefFile=".\variables.json"
    )
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    $subscriptionId=$v.variables.target_subscription_id.value
    $tenantname=$v.variables.tenant_name.value
    $vaultName=$v.variables.keyvault_name.value
    $vaultSecretBackups=@()
    $r=Get-wupVaultSecrets -vaultUrl $Global:vaultUrl | Write-Result
    if ($r.Success) {
        $secrets=$r.Value
        $secrets | %{
            $secretName=$_.id.split("/")[-1]
            $r=Get-wupVaultSecretBackup -secretName $secretName | Write-Result
            if ($r.Success) {
                $vaultSecretBackups+=[PSCustomObject]@{
                    vaultName=$vaultName
                    secretName=$secretName
                    secretBackup=$r.Value
                }
            }
        }
    }
    [PSCustomObject]@{
        tenantName=$tenantname
        subscriptionId=$subscriptionId
        vaultSecretBackups = $vaultSecretBackups
    } | ConvertTo-Json -Depth 100 | out-file ".\Snippets\vaultBackup_$($tenantname)_$($subscriptionId).json"
}
#END Bootstrap functions
#BEGIN Deployment functions
function Get-bicepVariableDefinition() {
    param(
        $variableDefFile,
        $targetEnvironmentName
    )
    $s=""
    $variableDef=$(gc -Path $variableDefFile -Raw) | ConvertFrom-Json
    $variables=$variableDef.Default
    $envVariables=$variableDef.$($targetEnvironmentName)
    $variables | get-member -MemberType NoteProperty | select -ExpandProperty name | %{
        $variable=$_
        if ($null -ne $variables.$($variable).schema) {
            if ($null -ne $variables.$($variable).schema.$($targetEnvironmentName)) {
                $v=$variables.$($variable).schema.$($targetEnvironmentName)
                $variables.$($_) | Add-Member -MemberType NoteProperty -Name "value" -Value $($v) -Force
            }
        }
        if ($null -ne $($envVariables.$($variable))) {
            if ($null -ne $($envVariables.$($variable).value)) {
                $variables.$($variable) | Add-Member -MemberType NoteProperty -Name "value" -Value $($envVariables.$($_).value) -Force
            }
        }
    }
    for ($i=0;$i -lt 2;$i++) {
        $variables | get-member -MemberType NoteProperty | select -ExpandProperty name | ? {$variables.$($_).value -like "*{*"} | %{
            $variable=$_
            $variables | Get-Member -MemberType NoteProperty | select -ExpandProperty name | %{
                $rVariable=$_
                if ($null -ne $variables.$($rVariable).value) {
                    $variables.$($variable).value=$variables.$($variable).value.replace("{$($rVariable.tolower())}",$variables.$($rVariable).value)
                }
            }
            $envVariables | Get-Member -MemberType NoteProperty | select -ExpandProperty name | %{
                $rVariable=$_
                if ($null -ne $envVariables.$($rVariable).value) {
                    $variables.$($variable).value=$variables.$($variable).value.replace("{$($rVariable.tolower())}",$envVariables.$($rVariable).value)
                }
            }
        }
    }
    $variables | get-member -MemberType NoteProperty | select -ExpandProperty name | %{
        $variable=$_
        if ($null -eq $variables.$($variable).value) {
            Write-Warning -Message "No value specified for variable $($variable)"
        } else {
            if ($variables.$($variable).secure -eq $true) {
                $s+="@secure()`r`n"
            }
            $s+="@description('$($variables.$($variable).description)')`r`nparam $($variable) $($variables.$($variable).type) = $(if ($($variables.$($variable).type) -eq 'string') {"'"})$($variables.$($variable).value)$(if ($($variables.$($variable).type) -eq 'string') {"'"})`r`n`r`n"
        }       
    }
    [PSCustomObject]@{
        variables=$variables
        variableString=$s
    }
}
function Set-DeplyomentDirectory() {
    param(
        $bicepVariableDefinition,
        $bicepTemplateFile,
        $deploymentDirectory,
        $bicepOptionsFile=".\IaC\bicepconfig.json",
        [switch]$autoApprove
    )
    if (Test-Path $deploymentDirectory) {
        remove-item -path $deploymentDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -Path $deploymentDirectory -ItemType Directory | Out-Null
    $bicepSource=gc -path $bicepTemplateFile -Raw -Encoding UTF8
    $bicepSource=$($bicepVariableDefinition.variableString)+"`r`n"+"`r`n"+$bicepSource
    $bicepSource | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\main.bicep"
    
    $s=""
    $s+='az login --tenant "' + $($bicepVariableDefinition.variables.tenant_name.value) + '"' + "`r`n"
    $s+='az account set --subscription "' + $($bicepVariableDefinition.variables.target_subscription_id.value) + '"' + "`r`n"
    $s+='az group create --name "' + $($bicepVariableDefinition.variables.resource_group_name.value) + '" --location "' + $($bicepVariableDefinition.variables.location.value) + '"' + "`r`n"
    $s+='az deployment group what-if --resource-group "' + $($bicepVariableDefinition.variables.resource_group_name.value) + '" --template-file "' + "$($deploymentDirectory)\main.bicep" + '"' + "`r`n"
    if (!($autoApprove)) {$s+='$answ=Read-Host -Prompt "Continue (y/n)"' + "`r`n"}
    if (!($autoApprove)) {$s+='if ($answ -eq "y") {' + "`r`n"}
    $s+='az deployment group create --resource-group "' + $($bicepVariableDefinition.variables.resource_group_name.value) + '" --template-file "' + "$($deploymentDirectory)\main.bicep" + '"' + "`r`n"
    if (!($autoApprove)) {$s+='}' + "`r`n"}

    $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\deploy.ps1"

    Copy-Item -Path $bicepOptionsFile -Destination "$($deploymentDirectory)\bicepconfig.bicep"
}
function Set-Environment() {
    param(
        $envName,
        $variableDefFile=".\variables.json",
        $bicepOptionsFile=".\IaC\bicepconfig.json",
        [switch]$autoApprove
    )
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    if ($autoApprove) {
        Set-DeplyomentDirectory -bicepVariableDefinition $v -bicepTemplateFile ".\IaC\source.bicep" -deploymentDirectory ".\IaC\Deployment_$($envName)" -autoApprove
    } else {
        Set-DeplyomentDirectory -bicepVariableDefinition $v -bicepTemplateFile ".\IaC\source.bicep" -deploymentDirectory ".\IaC\Deployment_$($envName)"
    }
    &".\IaC\Deployment_$($envName)\deploy.ps1"
}
function Get-ConfigForLocalDebug() {
    param(
        $envName,
        $variableDefFile=".\variables.json"
    )
    
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    $rgName=$v.variables.resource_group_name.value
    $funcName=$v.variables.function_app_name.value
    Connect-AzAccount -Tenant $v.variables.tenant_name.value -Subscription $v.variables.target_subscription_id.value | out-null
    Get-AzWebApp -ResourceGroupName $rgname -Name $funcName | 
    select -ExpandProperty siteconfig | select -expandproperty appsettings | 
    ? {$_.Name -ne 'MSI_CLIENT_ID'} | %{
        if (test-path -Path "Env:\$($_.Name)") {
            Set-item -Path "Env:\$($_.Name)" -Value $_.value                
        } else {
            New-item -Path "Env:\$($_.Name)" -Value $_.value
        }
    }    
    Import-Module '.\Azure Functions\Modules\widtools\widtools.psm1' -WarningAction SilentlyContinue -Force
    Import-Module '.\Azure Functions\Modules\widup\widup.psm1' -WarningAction SilentlyContinue -Force
    Initialize-WIDUp
}
function Deploy-AzureFunction() {
    param(
        $envName,
        $solutionBasePath="Azure Functions",
        $variableDefFile=".\variables.json"
    )
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    $rgName=$v.variables.resource_group_name.value
    $funcName=$v.variables.function_app_name.value
    az login --tenant $v.variables.tenant_name.value
    az account set --subscription $v.variables.target_subscription_id.value
    $zipPath="$($env:TEMP)\$($funcName).zip"
    Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue

    $functionNames=gci -path $solutionBasePath -Directory | select name,@{name="isfunctiondir";expression={Test-Path "$($_.fullname)\function.json"}} | ? {$_.isfunctionDir -eq $true} | select -ExpandProperty name

    Get-Item -Path "$solutionBasePath\requirements.psd1" | Compress-Archive -DestinationPath $zipPath
    Get-Item -Path "$solutionBasePath\profile.ps1" | Compress-Archive -DestinationPath $zipPath -Update
    Get-Item -Path "$solutionBasePath\host.json" | Compress-Archive -DestinationPath $zipPath -Update
    Get-Item -Path "$solutionBasePath\local.settings.json" | Compress-Archive -DestinationPath $zipPath -Update
    $functionNames | %{
        Get-Item -Path "$solutionBasePath\$($_)" | Compress-Archive -DestinationPath $zipPath -Update
    }
    Get-Item -Path "$solutionBasePath\Modules" | Compress-Archive -DestinationPath $zipPath -Update

    az functionapp deployment source config-zip -g $rgname -n $funcname --src $zipPath
}
function Deploy-FunctionKeys() {
    param(
        $envName,
        $solutionBasePath="Azure Functions",
        $variableDefFile=".\variables.json"
    )
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    $rgName=$v.variables.resource_group_name.value
    $funcName=$v.variables.function_app_name.value

    $functionKeys=Get-FunctionKeys

    $functionNames=gci -Path $solutionBasePath -Directory | ? {$_.name -like 'snow_*' -or $_.name -like 'bc_*' -or $_.name -like 'system_*'} | select -ExpandProperty name
    $functionNames | ? {$_ -like "snow_*"} | %{
        az functionapp function keys set --name $funcName --resource-group $rgName --function-name $($_) --key-name 'widup' --key-value $functionkeys.snowkey.value
    }
    $functionNames | ? {$_ -like "bc_*"} | %{
        az functionapp function keys set --name $funcName --resource-group $rgName --function-name $($_) --key-name 'widup' --key-value $functionkeys.bckey.value
    }
    $functionNames | ? {$_ -like "system_*"} | %{
        az functionapp function keys set --name $funcName --resource-group $rgName --function-name $($_) --key-name 'widup' --key-value $functionkeys.systemkey.value
    }
}
function Deploy-DVSchema() {
    param(
        $envName,
        $schemaDefinitionFile,
        $variableDefFile=".\variables.json"
    )
    
    $v=Get-bicepVariableDefinition -variableDefFile $variableDefFile -targetEnvironmentName $envName
    $dv_environment_url=$v.variables.dv_environment_url.value
    $dv_environment_id=$v.variables.dv_environment_id.value
    $dv_environment_solutionname=$v.variables.dv_environment_solutionname.value
    $dv_environment_publisherprefix=$v.variables.dv_environment_publisherprefix.value
    $r=get-schema -excelPath $schemaDefinitionFile -publisherPrefix $dv_environment_publisherprefix | Write-Result
    if ($r.Success) {
        $schema=$r.Value
        $r=Get-entityDefinitionAuthHeader -envUrl $dv_environment_url -solutionName $dv_environment_solutionname | Write-Result
    }
    if ($r.Success) {
        $dvHeader=$r.Value
        $r=Set-SchemaDVOptionsets -dvHeader $dvHeader -schema $schema -envUrl $dv_environment_url -publisherPrefix $dv_environment_publisherprefix | Write-Result
    }
    if ($r.Success) {
        $r=Set-SchemaDVEntities -dvHeader $dvHeader -schema $schema -envUrl $dv_environment_url -publisherPrefix $dv_environment_publisherprefix | Write-Result
    }
    if ($r.Success) {
        $r=Set-SchemaDVRelationShips -dvHeader $dvHeader -schema $schema -envUrl $dv_environment_url -publisherPrefix $dv_environment_publisherprefix | Write-Result
    }
    if ($r.Success) {
        $r=Set-SchemaDVBooleanOptionSets -dvHeader $dvHeader -schema $schema -envUrl $dv_environment_url -publisherPrefix $dv_environment_publisherprefix | Write-Result
    }    
}
#END Deployment functions

#BEGIN Debug functions
function Get-ItemFromQueue() {
    param(
        $queueName,
        [switch]$doNotDeleteMessage
    )
    $r=Get-accessToken -resourceURI $global:QueueStorageUri  
    $headers=@{
        'Content-Type'='application/json'
        'Authorization'='Bearer ' + $r.Value
        'Accept' = 'text/xml'
        'x-ms-version'='2017-11-09'
    }
    $url="$($global:QueueStorageUri)$($queueName)/messages"
    $response=Invoke-WebRequest -Uri $url -Headers $headers -Method Get
    $q=[xml]$response.Content.Substring($response.Content.IndexOf("<QueueMessagesList>"))
    $msg=$q.QueueMessagesList.QueueMessage
    $message=$([System.Text.Encoding]::UTF8.GetString([convert]::FromBase64String($q.QueueMessagesList.QueueMessage.MessageText))) | convertfrom-json
    if (!($doNotDeleteMessage)) {
        $deleteurl = "$($url)/$($msg.MessageId)?popreceipt=$($msg.PopReceipt)"
        $response = Invoke-WebRequest -Uri $deleteurl -Headers $headers -Method Delete
    }
    $message
}
function Reset-Jobqueue() {
    param(
        $schemaXlsPath
    )
    $baseSyncJobs=Import-Excel -Path $schemaXlsPath -WorksheetName "syncJobs"
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
    }
    $header=$r.value
    $url="$($Global:tableStorageUri)$($global:syncjobtablename)"
    $response=Invoke-WebRequest -Uri $url -Headers $header -Method Get -UseBasicParsing
    $rows=($response.Content | ConvertFrom-Json) | select -ExpandProperty value
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
        'If-Match'='*'
    }
    $header=$r.value
    $rows | % {
        $eurl="$($url)(PartitionKey='$($_.partitionKey)',RowKey='$($_.RowKey)')" 
        $response=Invoke-RestMethod -Uri $eurl -Headers $header -Method Delete -ContentType application/http -UseBasicParsing
    }
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
    }
    $header=$r.value
    $baseSyncJobs | % {
        $baseSyncJob=$_
        $body=[PSCustomObject]@{}
        $baseSyncJob.psobject.Properties | %{
            $body | Add-Member -MemberType NoteProperty -Name $_.name -Value $(if ($null -eq $_.value) {""} else {$_.value})
        }
        $body=$body | ConvertTo-Json
        $response=Invoke-WebRequest -Uri $url -headers $header -Method Post -Body $body -ContentType application/json -UseBasicParsing
    }
}
function Reset-ApiSchema() {
    param(
        $schemaXlsPath
    )
    $baseApiSchema=Import-Excel -Path $schemaXlsPath -WorksheetName "apischema"
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
    }
    $header=$r.value
    $url="$($Global:tableStorageUri)$($global:apischematablename)"
    $response=Invoke-WebRequest -Uri $url -Headers $header -Method Get -UseBasicParsing
    $rows=($response.Content | ConvertFrom-Json) | select -ExpandProperty value
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
        'If-Match'='*'
    }
    $header=$r.value
    $rows | % {
        $eurl="$($url)(PartitionKey='$($_.partitionKey)',RowKey='$($_.RowKey)')" 
        $response=Invoke-RestMethod -Uri $eurl -Headers $header -Method Delete -ContentType application/http -UseBasicParsing
    }
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
    }
    $header=$r.value
    $baseApiSchema | % {
        $baseApiSchemaLine=$_
        $body=[PSCustomObject]@{}
        $baseApiSchemaLine.psobject.Properties | %{
            $body | Add-Member -MemberType NoteProperty -Name $_.name -Value $(if ($null -eq $_.value) {""} else {$_.value})
        }
        $body=$body | ConvertTo-Json
        $response=Invoke-WebRequest -Uri $url -headers $header -Method Post -Body $body -ContentType application/json -UseBasicParsing
    }
}
function Reset-DepartmentSchema() {
    param(
        $schemaXlsPath
    )
    $xlsLines=Import-Excel -Path $schemaXlsPath -WorksheetName "departments"
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
    }
    $header=$r.value
    $url="$($Global:tableStorageUri)$($global:departmenttablename)"
    $response=Invoke-WebRequest -Uri $url -Headers $header -Method Get -UseBasicParsing
    $rows=($response.Content | ConvertFrom-Json) | select -ExpandProperty value
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
        'If-Match'='*'
    }
    $header=$r.value
    $rows | ? {$null -ne $_} | % {
        $eurl="$($url)(PartitionKey='$($_.partitionKey)',RowKey='$($_.RowKey)')" 
        $response=Invoke-RestMethod -Uri $eurl -Headers $header -Method Delete -ContentType application/http -UseBasicParsing
    }
    $r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
        'Accept' = 'application/json;odata=nometadata'
        'x-ms-version'='2017-11-09'
        'x-ms-date'=$((Get-Date).ToUniversalTime().toString('R'))
    }
    $header=$r.value
    $xlsLines | % {
        $xlsLine=$_
        $xlsLine     
        $body=[PSCustomObject]@{}
        $xlsLine.psobject.Properties | %{
            $body | Add-Member -MemberType NoteProperty -Name $_.name -Value $(if ($null -eq $_.value) {""} else {$_.value})
        }
        if (($xlsLine.psobject.Properties | select -ExpandProperty name) -notcontains "RowKey") {
            $body | Add-Member -MemberType NoteProperty -Name "RowKey" -Value $([GUID]::newGuid() | select -ExpandProperty guid)
        }
        if (($xlsLine.psobject.Properties | select -ExpandProperty name) -notcontains "PartitionKey") {
            $body | Add-Member -MemberType NoteProperty -Name "PartitionKey" -Value "p1"
        }
        $body=$body | ConvertTo-Json
        $response=Invoke-WebRequest -Uri $url -headers $header -Method Post -Body $body -ContentType "application/json; charset=utf-8" -UseBasicParsing
    }
}
function Get-restErrorResponseDetail() {
    param(
        [Parameter(ValueFromPipeline)]$ex
    )
    $ex.Response.GetResponseStream().position=0
    $(New-object System.IO.StreamReader($ex.Response.GetResponseStream())).ReadToEnd()
}
function Clear-cacheBlobs() {
    param(

    )
    $r=Get-AccessToken -resourceURI $global:blobstorageuri
    $blobToken=$r.Value
    $headers=@{
        "Authorization"="Bearer $blobToken"
        "x-ms-version"="2023-08-03"
        "x-ms-date"="$(([System.DateTime]::UtcNow).tostring('ddd, dd MMM yyyy HH:mm:ss')) GMT"
    }
    $uri="$($global:blobstorageuri)$($global:cachecontainername)?restype=container&comp=list"
    $response=Invoke-webrequest -Uri $uri -Headers $headers -Method Get -ContentType "text/xml" -UseBasicParsing
    $blobIDs=[xml]$response.Content.Substring(3) | select -ExpandProperty EnumerationResults | select -ExpandProperty blobs | select -ExpandProperty blob | select -ExpandProperty name
    $blobids | %{
        $r=Remove-wupBlobData -blobID $_
        $r.message
    }
}
#END Debug functions
