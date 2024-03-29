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
function Set-dplDirectoryIac() {
    param(
        $variableDefinition,
        $deploymentDirectory,
        $bicepTemplateFile=".\iac\source.bicep",
        $bicepOptionsFile=".\iac\bicepconfig.json"
    )
    try {
        if (Test-Path $deploymentDirectory) {
            remove-item -path $deploymentDirectory -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -Path $deploymentDirectory -ItemType Directory | Out-Null
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
        $s+='az group create --name "' + $($variableDefinition.variables.resource_group_name.value) + '" --location "' + $($variableDefinition.variables.location.value) + '"' + "`r`n"
        $s+='$output=$(az deployment group create --resource-group "' + $($variableDefinition.variables.resource_group_name.value) + '" --template-file "' + "main.bicep" + '")' + "`r`n"
        $s+='@(0..$($output.length-1)) | %{' + "`r`n"
        $s+='    Write-Host $output[$_]' + "`r`n"
        $s+='}' + "`r`n"
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
        if (Test-Path $deploymentDirectory) {
            remove-item -path $deploymentDirectory -Recurse -Force -ErrorAction SilentlyContinue
        }
        New-Item -Path $deploymentDirectory -ItemType Directory | Out-Null
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