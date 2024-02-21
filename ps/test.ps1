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
  

$r=Get-dplHttpAuthHeader -resourceURI "https://graph.microsoft.com"
$headers=$r.Value

$resourceName="appReg-hofb-wup-tst-sn-01"
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
