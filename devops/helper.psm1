


function New-Result() {
    param(
        [parameter(Mandatory=$true)][bool]$success,
        [string]$message="",
        [System.Exception]$exception=$null,
        [System.Object]$value=$null,
        [ValidateSet("Verbose","Information","Warning","Error")]$logLevel="Information"
    )
    if (($exception -ne $null) -and ($logLevel -eq "Information")) {$logLevel="Error"}
    if ($null -ne $exception) {
        if ($null -ne $exception.response) {
            try {
                $exception.Response.GetResponseStream().position=0
                $responseMessage=$(New-object System.IO.StreamReader($Exception.Response.GetResponseStream())).ReadToEnd()
                $message="$($message): $($responseMessage)"
            } catch {
            }
        } else {
            $message="$($message): $($exception.message)"
        }
    }
    [PSCustomObject]@{
        Success=$success
        Message=$message
        Exception=$exception
        Value=$value
        LogLevel=$logLevel
    }
}
function Write-dplResult() {
    param
    (
	    [Parameter(Mandatory = $true, ValueFromPipeline = $true)][PSCustomObject[]]$result,
        [switch]$NoPassThru
    )
    BEGIN {}
    PROCESS {
        switch ($result.LogLevel) {
            "Information" {
                Write-Host $result.message -ForegroundColor Green
                break
            }
            "Warning" {  
                Write-Host $result.message -ForegroundColor DarkYellow
                break
            }
            "Error" {
                Write-Host $result.message -ForegroundColor Red
                break
            }
            Default {
                Write-Host $result.Message -ForegroundColor White
            }      
        }
        if (!$NoPassThru) {$result}
    }
    END {}
}
function Get-dplVariableDefinition() {
    param(
        $variableDefFile=".\variables.json",
        $targetEnvironmentName
    )
    try {
        $errors=""
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
                $errors+="[No value specified for variable $($variable)] "
            } else {
                if ($variables.$($variable).secure -eq $true) {
                    $s+="@secure()`r`n"
                }
                $s+="@description('$($variables.$($variable).description)')`r`nparam $($variable) $($variables.$($variable).type) = $(if ($($variables.$($variable).type) -eq 'string') {"'"})$($variables.$($variable).value)$(if ($($variables.$($variable).type) -eq 'string') {"'"})`r`n`r`n"
            }       
        }
        $obj=[PSCustomObject]@{
            variables=$variables
            variableString=$s
        }
        if ($errors.length -eq 0) {
            $r=New-Result -success $true -message "Successfully loaded variable definition ($($variableDefFile))" -value $obj -logLevel Information
        } else {
            $r=New-Result -success $false -message "Errors loading variable definition: $($errors)"
        }
    } catch {
        $r=New-Result -success $false -message "Unexpected error loading variable definition ($($variableDefFile))" -exception $_.Exception -logLevel Error
    }
    $r
}
function Set-dplDeploymentDirectory() {
    param(
        $deploymentDirectory
    )
    if (Test-Path $deploymentDirectory) {
        remove-item -path $deploymentDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -Path $deploymentDirectory -ItemType Directory | Out-Null
}
function Set-dplDirectoryIac() {
    param(
        $variableDefinition,
        $deploymentDirectory,
        $bicepTemplateFile=".\iac\source.bicep",
        $bicepOptionsFile=".\iac\bicepconfig.json"
    )
    try {
        Set-dplDeploymentDirectory -deploymentDirectory $deploymentDirectory
        $bicepSource=gc -path $bicepTemplateFile -Raw -Encoding UTF8
        $bicepSource=$($variableDefinition.variableString)+"`r`n"+"`r`n"+$bicepSource
        $bicepSource | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\main.bicep"
        
        $s=""
        $s+='az group create --name "' + $($variableDefinition.variables.resource_group_name.value) + '" --location "' + $($variableDefinition.variables.location.value) + '"' + "`r`n"
        $s+='$output=$(az deployment group what-if --resource-group "' + $($variableDefinition.variables.resource_group_name.value) + '" --template-file "' + "main.bicep" + '")' + "`r`n"
        $s+='@(0..$($output.length-1)) | %{' + "`r`n"
        $s+='    Write-Host $output[$_]' + "`r`n"
        $s+='}' + "`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\plan.ps1"

        $s=""
        $s+='Write-Host "Creating resource group"'+"`r`n"
        $s+='az group create --name "' + $($variableDefinition.variables.resource_group_name.value) + '" --location "' + $($variableDefinition.variables.location.value) + '"' + "`r`n"
        $s+='Write-Host "Deleting bicep managed identity for bicep script deployment"'+"`r`n"
        $s+='$mi=$((az identity delete -g "' + $($variableDefinition.variables.resource_group_name.value) + '" -n "' + $($variableDefinition.variables.bicep_managed_identity_name.value) + '") | convertfrom-json)' + "`r`n"
        $s+='Start-Sleep -seconds 20' + "`r`n"
        $s+='Write-Host "Creating new managed identity for bicep script deployment"'+"`r`n"
        $s+='$mi=$((az identity create -g "' + $($variableDefinition.variables.resource_group_name.value) + '" -n "' + $($variableDefinition.variables.bicep_managed_identity_name.value) + '") | convertfrom-json)' + "`r`n"
        $s+='Start-Sleep -seconds 20' + "`r`n"
        $s+='Write-Host "Assigning application administrator role to managed identity for bicep script deployment"'+"`r`n"
        $s+='$role=$((az rest --headers Content-Type=application/json --method POST --uri ' + "'" + 'https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments' + "'" + ' --body $(' + "'" + '{\"principalId\": \"' + "'" + ' + $($mi.principalId) + ' + "'" + '\", \"roleDefinitionId\": \"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3\", \"directoryScopeId\": \"/\"}' + "'" + ')) | convertfrom-json)' + "`r`n"
        $s+='Write-Host "Deploying resources using bicep"'+"`r`n"
        $s+='$output=$(az deployment group create --resource-group "' + $($variableDefinition.variables.resource_group_name.value) + '" --template-file "' + "main.bicep" + '")' + "`r`n"
        $s+='@(0..$($output.length-1)) | %{' + "`r`n"
        $s+='    Write-Host $output[$_]' + "`r`n"
        $s+='}' + "`r`n"
        $s+='Write-Host "Deleting bicep managed identity for bicep script deployment"'+"`r`n"
        $s+='$mi=$((az identity delete -g "' + $($variableDefinition.variables.resource_group_name.value) + '" -n "' + $($variableDefinition.variables.bicep_managed_identity_name.value) + '") | convertfrom-json)' + "`r`n"
        $s+='Write-Host "Retrieving url of deployed static web app"'+"`r`n"
        $s+='$swaUrl="https://$($(az staticwebapp show --name "' + $($variableDefinition.variables.static_web_app_name.value) + '" -o tsv  --query "defaultHostname"))/.auth/login/aad/callback"' + "`r`n"
        $s+='Write-Host "Retrieving registered application deployed for swa authentication"'+"`r`n"
        $s+='$appid=$((az ad app list --display-name "' + $($variableDefinition.variables.swa_registered_app_name.value) + '") | convertfrom-json | select -first 1 | select -expandproperty appid)' + "`r`n"
        $s+='Write-Host "Setting redirect url of registered application"'+"`r`n"
        $s+='az ad app update --id $appid --web-redirect-uris $swaUrl --enable-id-token-issuance' + "`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\apply.ps1"

        Copy-Item -Path $bicepOptionsFile -Destination "$($deploymentDirectory)\bicepconfig.json"
        $r=New-Result -success $true -message "Successfully created iac deployment artifacts in ($($deploymentDirectory))" -value $null -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error creating iac deployment artifacts in ($($deploymentDirectory))" -exception $_.Exception -logLevel Error            
    }
    $r
}
function Set-dplDirectoryPS() {
    param(
        $variableDefinition,
        $deploymentDirectory
    )
    try {
        Set-dplDeploymentDirectory -deploymentDirectory $deploymentDirectory
        $solutionBasePath="ps\Azure Functions"
        $rgName=$variableDefinition.variables.resource_group_name.value
        $funcName=$variableDefinition.variables.function_app_name.value
        $vaultName=$variableDefinition.variables.keyvault_name.value
        $zipPath="$($deploymentDirectory)\$($funcName).zip"
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

        $s='Write-Host -message "No plan mode for az functionapp deployment"'
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\plan.ps1"

        $s="Write-Host 'Deploying function app code'" + "`r`n"
        $s+='$output=$(az functionapp deployment source config-zip -g "' + $($rgName) + '" -n "' + $($funcName) + '" --src "' + $($funcName) + '.zip" --only-show-errors) | convertfrom-json' + "`r`n"
        $s+='Write-Host "Result: $($output.provisioningState)"' + "`r`n"
        $s+="Write-Host 'Deploying function app keys'" + "`r`n"
        $keys=gci -path $solutionBasePath -Directory | ? {$_.name -like "*_*"} | select @{name="prefix";expression={"$($_.Name.Split('_')[0])"}},@{name="keyName";expression={"functionkey$($_.Name.Split('_')[0])"}} | select -Unique prefix,keyname
        $keys | %{
            $key=$_
            $s+='$' + $($key.keyname) + '=$(az keyvault secret show --vault-name "' + $vaultName + '" --name "' + $($key.keyname) + '" 2>$null) | convertfrom-json | select -ExpandProperty value' + "`r`n"
            $s+='if ($null -eq $' + $($key.keyname) + ') {' + "`r`n"
            $s+='    $' + $($key.keyname) + '=$(az keyvault secret set --vault-name "' + $vaultName + '" --name "' + $($key.keyname) + '" --value "$(-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | %{[char]$_}))") | convertfrom-json | select -ExpandProperty value' + "`r`n"
            $s+='}' + "`r`n"
        }
        $keys | %{
            $key=$_
            $functionNames | ? {$_ -like "$($key.prefix)_*"} | %{
                $functionName=$_
                $s+='$output=$(az functionapp function keys set --name "'+$funcName+'" --resource-group "'+$rgName+'" --function-name "'+$($functionName)+'" --key-name "widup" --key-value "$functionkey'+$($key.prefix)+'" --only-show-errors) | convertfrom-json' + "`r`n"
                $s+='Write-Host "OK: $($output.id)"' + "`r`n"
            }
        }
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\apply.ps1"

        $r=New-Result -success $true -message "Successfully created ps deployment artifacts in ($($deploymentDirectory))" -value $null -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error creating ps deployment artifacts in ($($deploymentDirectory))" -exception $_.Exception -logLevel Error            
    }
    $r
    #az functionapp deployment source config-zip -g $rgname -n $funcname --src $zipPath
}
function Set-dplDirectoryDoc() {
    param(
        $variableDefinition,
        $deploymentDirectory
    )
    try {
        Set-dplDeploymentDirectory -deploymentDirectory $deploymentDirectory
        New-item -Path "$($deploymentDirectory)\doc" -ItemType Directory
        ipmo .\devops\docHelper.psm1 -force
        set-wupDok -htmlOutputPath "$($deploymentDirectory)\doc"
        $c=Get-Content -Path ".\doc\staticwebapp.config.source" -Encoding UTF8 -Raw
        $c=$c.Replace("###tenantid###",$variableDefinition.variables.tenant_id.value)
        $c | out-file "$($deploymentDirectory)\doc\staticwebapp.config.json" -Encoding utf8       

        $s='Write-Host -message "No plan mode for doc deployment"'
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\plan.ps1"

        $s="Write-Host 'Preparing documentation deployment'" + "`r`n"
        $s+='Write-Host "Retrieving deployment token from static web app"'+"`r`n"
        $s+='$swatoken=$(az staticwebapp secrets list --name "' + $($variableDefinition.variables.static_web_app_name.value) + '" -o tsv --query "properties.apiKey")' + "`r`n"
        $s+='Write-Host "Setting github actions environment variable for swatoken"'+"`r`n"
        $s+='echo "SWATOKEN=$swatoken" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append' + "`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\apply.ps1"

        $r=New-Result -success $true -message "Successfully created doc deployment artifacts in ($($deploymentDirectory))" -value $null -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error creating doc deployment artifacts in ($($deploymentDirectory))" -exception $_.Exception -logLevel Error            
    }
    $r
}
function Set-dplDirectoryTst() {
    param(
        $variableDefinition,
        $deploymentDirectory
    )
    try {
        Set-dplDeploymentDirectory -deploymentDirectory $deploymentDirectory

        $s='Write-Host -message "No plan mode for tst deployment"'
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\plan.ps1"

        $s="Write-Host 'Preparing test deployment'" + "`r`n"
        $s+='$fk=$(az keyvault secret show --name "functionkeymonitor" --vault-name "' + $($variableDefinition.variables.keyvault_name.value) + '") | convertfrom-json | select -ExpandProperty value'+"`r`n"
        $s+='$hdr=@{"Content-Type"="application/json";"x-functions-key"=$fk}'+"`r`n"
        $s+='$rsp=Invoke-RestMethod -Uri "' + $($variableDefinition.variables.api_base_url.value) + 'api/monitor/status" -Headers $hdr -Method get'+"`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\apply.ps1"

        $r=New-Result -success $true -message "Successfully created doc deployment artifacts in ($($deploymentDirectory))" -value $null -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error creating doc deployment artifacts in ($($deploymentDirectory))" -exception $_.Exception -logLevel Error            
    }
    $r
}
function Set-dplDirectoryDat() {
    param(
        $variableDefinition,
        $deploymentDirectory
    )
    try {
        Set-dplDeploymentDirectory -deploymentDirectory $deploymentDirectory

        $s="Write-Host 'Running data deployment in plan mode'" + "`r`n"
        $s+='Install-Module -Name ImportExcel -Confirm:$False -Force' + "`r`n"
        $s+='ipmo ImportExcel' + "`r`n"
        $s+='ipmo .\devops\helper.psm1' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\plan.ps1"

        $s="Write-Host 'Running data deployment in apply mode'" + "`r`n"
        $s+='Install-Module -Name ImportExcel -Confirm:$False -Force' + "`r`n"
        $s+='ipmo ImportExcel' + "`r`n"
        $s+='ipmo .\devops\helper.psm1' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s+='' + "`r`n"
        $s | out-file -Encoding utf8 -FilePath "$($deploymentDirectory)\apply.ps1"

        $r=New-Result -success $true -message "Successfully created doc deployment artifacts in ($($deploymentDirectory))" -value $null -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error creating doc deployment artifacts in ($($deploymentDirectory))" -exception $_.Exception -logLevel Error            
    }
    $r
}
function Get-dplHttpAuthHeader() {
    param(
        $resourceURI,
        $additionalHeaderAttributes = @{}
    )
    try {
        $accessToken=(az account get-access-token --resource $resourceURI | ConvertFrom-Json | select -ExpandProperty accessToken)
        $header=@{
            'Content-Type'='application/json'
            'Authorization'='Bearer ' + $accessToken
        }
        $additionalHeaderAttributes.GetEnumerator() |%{
            if ($header.ContainsKey($_.name)) {$header.Item($_.name)=$_.value}
            else {$header.Add($_.name,$_.value)}

        }
        $r=New-Result -success $true -message "Successfully retrieved http auth header for $resourceURI" -value $header
    } catch {
        $r=New-Result -success $false -message "Error retreiving http auth header for $resourceURI" -exception $_.Exception
    }
    $r
}
function Get-dplFunctionAppSettings() {
    param(
        $variableDefinition,
        $deploymentDirectory
    )
    try {

    } catch {
        $r=new
    }
    $r

    $rgName=$variableDefinition.variables.resource_group_name.value
    $funcName=$variableDefinition.variables.function_app_name.value
    $(az functionapp config appsettings list --name $funcName --resource-group $rgname) | convertfrom-json | %{

    }
}
function Update-dplTableData() {
    param(
        $tableName,
        $mode
    )
    try {
        $pe=$(az storage account show --resource-group $variableDefinition.variables.resource_group_name.value --name $variableDefinition.variables.storage_account_name.value -o tsv --query 'primaryEndpoints.table')
        $hdr=Get-dplHttpAuthHeader -resourceURI $pe -additionalHeaderAttributes @{"Accept" = "application/json;odata=nometadata";"x-ms-version"="2017-11-09"} | select -ExpandProperty value
        $trs=@();$ers=@()
        $trs+=Invoke-RestMethod -Uri "$($pe)$($tableName)" -Headers $hdr -Method get | select -ExpandProperty value
        $ers+=Import-Excel -path ".\dat\wupData.xlsx" -WorksheetName $tableName | ? {$_.rowkey -ne $null}
        $ers | % {$er=$_;$er | get-member -MemberType NoteProperty | select -expandproperty name | %{if ($null -eq $er.$($_)) {$er.$($_)=""}}}
        $ers | ? {$null -ne $_} | %{
            $er=$_
            $tr=$trs | ? {$_.rowkey -eq $er.rowkey}
            if ($null -eq $tr) {
                $action="add"
            } else {
                $same=$true
                $er | get-member -MemberType NoteProperty | ? {$_.name -notlike "*at" -and $_.name -ne "action"} | select -ExpandProperty name | %{
                    $att=$_
                    $same=$same -and ($er.$($_) -eq $tr.$($_))
                }
                if ($same) {$action="same"} else {$action="update"}
            }
            $er | Add-Member -MemberType NoteProperty -Name "action" -Value $action -Force
        }
        $trs | ? {$null -ne $_} | %{
            $tr=$_
            $er=$ers | ? {$_.rowkey -eq $tr.rowkey}
            if ($null -eq $er) {
                $tr | Add-Member -MemberType NoteProperty -Name "action" -Value "remove" -Force
                $ers+=$tr
            }
        }

        Write-Host "$([PSCustomObject]@{
            details=$ers | sort action | convertto-json
            same=$(,@($ers | ? {$_.action -eq 'same'})).count
            add=$(,@($ers | ? {$_.action -eq 'add'})).count
            update=$(,@($ers | ? {$_.action -eq 'update'})).count
            remove=$(,@($ers | ? {$_.action -eq 'remove'})).count
        } | convertto-json)"

        if ($mode -eq "apply") {
            $ers | ? {$_.action -in @('add','update')} | %{
                #upsert
                $er=$_
                Write-Host "Upsert record $($er.rowkey)"
                $b=[PSCustomObject]@{}            
                $er.psobject.Properties | ? {$_.name -notlike "action"} | %{$b | Add-Member -MemberType NoteProperty -Name $_.name -Value $_.value}
                $hdr=Get-dplHttpAuthHeader -resourceURI $pe -additionalHeaderAttributes @{"Accept" = "application/json;odata=nometadata";"x-ms-version"="2017-11-09";"x-ms-date"=$((Get-Date).ToUniversalTime().toString('R'))} | select -ExpandProperty value
                $response=Invoke-RestMethod -Uri "$($pe)$($tableName)(PartitionKey='$($er.PartitionKey)',RowKey='$($er.RowKey)')" -Headers $hdr -Method put -body $($b | convertto-json) -UseBasicParsing
            }
            $ers | ? {$_.action -in @('remove')} | %{
                #remove
                $er=$_
                Write-Host "Remove record $($er.rowkey)"
                $hdr=Get-dplHttpAuthHeader -resourceURI $pe -additionalHeaderAttributes @{"Accept" = "application/json;odata=nometadata";"x-ms-version"="2017-11-09";"x-ms-date"=$((Get-Date).ToUniversalTime().toString('R'));"If-Match"="*"} | select -ExpandProperty value
                $response=Invoke-RestMethod -Uri "$($pe)$($tableName)(PartitionKey='$($er.PartitionKey)',RowKey='$($er.RowKey)')" -Headers $hdr -Method delete -ContentType application/http -UseBasicParsing
            }
        }
    } catch {
        Write-Host "Error updating table $($tableName) in $($mode) mode"
        Write-Host $_.Exception
    }
}
