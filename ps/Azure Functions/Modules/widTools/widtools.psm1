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
function Write-Result() {
    param
    (
	    [Parameter(Mandatory = $true, ValueFromPipeline = $true)][PSCustomObject[]]$result,
        [switch]$NoPassThru
    )
    BEGIN {}
    PROCESS {
        switch ($result.LogLevel) {
            "Information" {  
                Write-Information  -MessageData $result.Message
                break
            }
            "Warning" {  
                Write-Warning -Message $result.Message
                break
            }
            "Error" {
                if ($null -ne $result.exception) {
                    if ($null -ne $result.exception.response) {
                        try {
                            $result.Exception.Response.GetResponseStream().position=0
                            $responseMessage=$(New-object System.IO.StreamReader($result.Exception.Response.GetResponseStream())).ReadToEnd()
                            Write-Error -Message "$($result.Message): $($responseMessage)"
                        } catch {
                            Write-Error -Message $result.Message -Exception $result.Exception
                        }
                    } else {
                        Write-Error -Message $result.Message -Exception $result.Exception
                    }
                } else {
                    Write-Error -Message $result.Message
                }            
                break
            }
            Default {
                Write-Verbose -Message $result.Message -Verbose
            }      
        }
        if (!$NoPassThru) {$result}
    }
    END {}
}
function Invoke-widWebRequest() {
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
function Invoke-widRestMethod() {
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
function Get-AccessToken {
    param(
        [string][Parameter(Mandatory=$true)]$resourceURI
    )
    try {
        
        if ($null -eq $env:IDENTITY_ENDPOINT) {
            $accessToken=(az account get-access-token --resource $resourceURI | ConvertFrom-Json | select -ExpandProperty accessToken)
        } else {
            if ($null -ne $env:MSI_CLIENT_ID) {
                $tokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$resourceURI&client_id=$($env:MSI_CLIENT_ID)&api-version=2019-08-01"
            } else {
                $tokenAuthURI = $env:IDENTITY_ENDPOINT + "?resource=$resourceURI&api-version=2019-08-01"
            }
            $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"X-IDENTITY-HEADER"="$env:IDENTITY_HEADER"} -Uri $tokenAuthURI
            $accessToken = $tokenResponse.access_token  
        }
        $r=New-Result -success $true -message "Successfully retrieved authentication token for $resourceURI" -value $accessToken
    } catch {
        $r=New-Result -success $false -message "Error retreiving authentication token for $resourceURI" -exception $_.Exception
    }
    $r
}
function Get-AuthHeader {
    param(
        [string]$resourceURI,
        $accessToken=$null,
        $additionalHeaderAttributes = @{}
    )
    if ($null -eq $accessToken) {
        $r=Get-AccessToken -resourceURI $resourceURI
        if ($r.Success) {
            $accessToken = $r.value
        }
    } else {
        $r=New-Result -success $true
    }
    if ($r.Success) {
        $baseHeader=@{
            'Content-Type'='application/json'
            'Authorization'='Bearer ' + $accessToken
        }
        $additionalHeaderAttributes.GetEnumerator() |%{
            if ($null -ne $_.value) {
                $_.value=$_.Value.replace('###accesstoken###',$accessToken)
            }
            if ($baseHeader.ContainsKey($_.name)) {
                $baseHeader.Item($_.name)=$_.value
            } else {
                $baseHeader.Add($_.name,$_.value)
            }
        }
        $r=New-Result -success $true -message "Successfully retrieved authentication header for $resourceURI" -value $baseHeader
    }
    $r
}
function Merge-HeaderAttributes() {
    param(
        [Parameter(ValueFromPipeline=$true)]$authHeader,
        [hashtable]$additionalHeaderAttributes
    )
    $ht=[hashtable]@{}
    $authHeader.GetEnumerator() | %{if ($_.name -in @("Authorization","Content-Type")) {$ht[$_.key]=$authHeader[$_.key]}}
    $ht+=$additionalHeaderAttributes
    $ht
}
Function Compress-String() {
    param(
        [string]$s
    )
    try {
        $Data=[System.Text.Encoding]::UTF8.GetBytes($s)
        $ms = New-Object IO.MemoryStream
        $cs = New-Object System.IO.Compression.GZipStream ($ms, [Io.Compression.CompressionMode]"Compress")
        $cs.Write($Data, 0, $Data.Length) | out-null
        $cs.Close() | out-null
        $compressedString=[Convert]::ToBase64String($ms.ToArray())
        $ms.Close() | out-null
        $compressedString
    } catch {
        $false
    }
}
Function Expand-String() {
    param(
        [string]$s
    )
    $binaryData = [System.Convert]::FromBase64String($s)       
    $ms = New-Object System.IO.MemoryStream
    $ms.Write($binaryData, 0, $binaryData.Length) | Out-Null
    $ms.Seek(0,0) | Out-Null
    $cs = New-Object System.IO.Compression.GZipStream($ms, [IO.Compression.CompressionMode]"Decompress")
    $sr = New-Object System.IO.StreamReader($cs)
    $decompressedString=$sr.ReadToEnd()
    $decompressedString
}
function Convert-NullToEmptyString() {
    param(
        $value
    )
    if ($value -eq $null) {""} else {$value}
}
function Set-DvData() {
    param(
        $envUri,
        $accessToken=$null, #in case of batch
        $tableName,
        $body,
        $primaryKey="",
        $upsertQuery="",
        $select="",
        $dvVersion="v9.2",
        $ifnomatch="null",
        [dvBatch]$dvBatch=$null,
        $useDvBatchChangeSet=$false
    )
    if ($upsertQuery.Length -gt 0) {
        $qs="($($upsertQuery))"
        $method="PATCH"
    } elseif ($primaryKey.length -gt 0) {
        $qs="($($primaryKey))"
        $method="PATCH"
    } else {
        $qs=""
        $method="POST"
    }
    if ($select.Length -gt 0) {
        $qs+="?`$select=$select"
    }
    $uri="$($envUri)/api/data/$($dvVersion)/$($tableName)$($qs)"
    if ($null -eq $dvBatch) {
        $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
            @{"name"="OData-MaxVersion";"value"="4.0"},
            @{"name"="OData-Version";"value"="4.0"},
            @{"name"="Prefer";"value"="return=representation"}
        )
        #@{"name"="If-None-Match";"value"=$ifnonmatch}
        if ($r.Success) {
            $authHeader=$r.Value
            try {
                $response=Invoke-WebRequest -Headers $authHeader -Uri $uri -Body $body -Method $method -UseBasicParsing -ContentType "application/json; charset=utf-8"
                #$response=Invoke-widWebRequest -Headers $authHeader -Uri $uri -Body $body -Method $method -UseBasicParsing -ContentType "application/json; charset=utf-8"
                $data=$response.Content
                $r=New-Result -success $true -message "Successfully added/updated record in table $tableName" -value $data
            } catch {
                $r=New-Result -success $false -message "Error adding/updating record in table $tableName" -exception $_.Exception
            }
        }
    } else {
        $r=$dvBatch.AddRequest($uri,$method,"application/json; charset=utf-8; type=entry",$body,$useDvBatchChangeSet)
    }
    $r
}
function Get-DvData() {
    param(
        $envUri,
        $accessToken=$null, #in case of batch
        $tableName,
        $dvVersion="v9.2",
        $filter="",
        $select="",
        $maxpagesize=10,
        [dvBatch]$dvBatch=$null
    )
    $qs=""
    if ($filter.Length -gt 0) {
        $qs+="&`$filter=$filter"
    }
    if ($select.Length -gt 0) {
        $qs+="&`$select=$select"
    }
    if ($qs.Length -gt 0) {
        $qs="?"+$qs.Substring(1)
    }
    $uri="$($envUri)/api/data/$($dvVersion)/$($tableName)$($qs)"
    if ($null -eq $dvBatch) {
        $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
            @{"name"="OData-MaxVersion";"value"="4.0"},
            @{"name"="OData-Version";"value"="4.0"},
            @{"name"="Prefer";"value"="odata.maxpagesize=$maxpagesize"}
        )
        if ($r.Success) {
            $authHeader=$r.Value
            $data=@()
            $r=$null
            try {
                while ($null -ne $uri) {
                    try {
                        $response=Invoke-RestMethod -Headers $authHeader -Uri $uri  -Method get -UseBasicParsing
                        $data+=$response.value
                        $uri=$response.'@odata.nextLink'
                    } catch {
                        $uri=$null
                        $r=New-Result -success $false -message "Error retreiving records from table $tableName" -exception $_.Exception
                    }
                }
                if ($null -eq $r) {
                    $r=New-Result -success $true -message "Successfully retrieved $($data.count) records from table $tableName" -value $data
                }
            } catch {
                $r=New-Result -success $false -message "Error retreiving records from table $tableName" -exception $_.Exception
            }
        }
    } else {
        $r=$dvBatch.AddRequest($uri,"GET")
    }
    $r
}
function Set-DvFile() {
    param(
        $envUri,
        $accessToken,
        $tableName,
        $fieldName,
        $entityId,
        $fileName,
        $binaryData,
        $dvVersion="v9.2"
    )
    $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
        @{"name"="OData-MaxVersion";"value"="4.0"},
        @{"name"="OData-Version";"value"="4.0"},
        @{"name"="x-ms-file-name";"value"="$($fileName)"}
    )
    if ($r.Success) {
        $authHeader=$r.Value
        try {
            $body=$binaryData
            $url="$($envUri)/api/data/$($dvVersion)/$($tableName)($($entityId))/$($fieldName)"
            $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method Patch -Body $body -ContentType "application/octet-stream" -UseBasicParsing -SkipHeaderValidation
            #$response=Invoke-widWebRequest -Uri $url -Headers $authHeader -Method Patch -Body $body -ContentType "application/octet-stream" -UseBasicParsing #-SkipHeaderValidation
            $r=New-Result -success $true -message "Successfully added/updated file column $fieldName in table $tableName" -value $null
        } catch {
            $r=New-Result -success $false -message "Error adding/updating file column $fieldName in table $tableName" -exception $_.Exception
        }
    }
    $r
}
function Get-DvFile() {
    param(
        $envUri,
        $accessToken,
        $tableName,
        $fieldName,
        $entityId,
        $dvVersion="v9.2"
    )
    $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
        @{"name"="OData-MaxVersion";"value"="4.0"},
        @{"name"="OData-Version";"value"="4.0"}
    )
    if ($r.Success) {
        $authHeader=$r.Value
        try {
            $url="$($envUri)/api/data/$($dvVersion)/$($tableName)($($entityId))/$($fieldName)/`$value"

            $response=Invoke-WebRequest -Uri $url -Headers $authHeader -Method Get
            #$response=Invoke-widWebRequest -Uri $url -Headers $authHeader -Method Get
            [byte[]]$b=$response.Content
            $fileName=$response.Headers.Item('x-ms-file-name')
            $data=[PSCustomObject]@{
                fileName = $fileName
                fileData = $b
            }
            $r=New-Result -success $true -message "Successfully retrieved file data from column $fieldName in table $tableName" -value $data -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error retreiving file data from column $fieldName in table $tableName" -exception $_.Exception
        }
    }
    $r
}
class dvRequest {
    $url
    $method
    $contentType
    $body
    $useChangeSet
    dvRequest(
        $url,
        $method,
        $contentType,
        $body=$null,
        $useChangeSet
    )
    {
        $this.url=$url
        $this.method=$method
        $this.ContentType=$contentType
        $this.body=$body
        $this.useChangeSet=$useChangeSet
    }
    [string]render()
    {
        $s=""
        $s+="$($this.method) $($this.url) HTTP/1.1"+"`r`n"
        if ($null -ne $this.body) {
            $s+="Content-Type: $($this.contentType)"+"`r`n"
            $s+="`r`n"
            $s+="$($this.body)"+"`r`n"
        } else {
            $s+="`r`n"
        }
        return $s
    }
}
class dvResponse {
    $dataObject
    $data
    $httpCode
    $location
    $request
    dvResponse()
    {
        $this.dataObject=[PSCustomObject]@{}
        $this.data=[PSCustomObject]@{}
        $this.httpCode=0
        $this.location=""
        $this.request=$null
    }
}
class dvBatch {
    [string] hidden $dvVersion
    [dvRequest[]]$requests
    [dvResponse[]]$responses
    [string] hidden $batchID
    [string] hidden $body

    dvBatch() 
    {
        $this.dvVersion="v9.2"
        $this.batchID="batch_$([GUID]::NewGuid() | select -ExpandProperty guid)"
        $this.requests=@()
        $this.responses=@()
    }

    [PSCustomObject]AddRequest(
        $url,
        $method
    )
    {
        return $this.AddRequest($url,$method,$null,$null,$false)
    }

    [PSCustomObject]AddRequest(
        $url,
        $method,
        $contentType,
        $body
    )
    {
        return $this.AddRequest($url,$method,$contentType,$body,$false)
    }

    [PSCustomObject]AddRequest(
        $url,
        $method,
        $contentType,
        $body,
        $useChangeSet
    )
    {
        try {
            if ($method -eq "GET") {$useChangeSet=$false}
            $this.requests+=[dvRequest]::new($url,$method,$contentType,$body,$useChangeSet)
            $r=New-Result -success $true -message "Successfully added request to dvBatch" -logLevel Information
        } catch {
            $r=New-Result -success $false -message "Error adding request to dvBatch" -exception $($_.exception) -logLevel Error
        }
        return $r
    }

    [PSCustomObject]run(
        $envUri,
        $accessToken,
        $dvHeader=$null
    )
    {
        $currentChangeSet=""
        $batchHeader=$null
        $this.body=""
        $contentID=1
        $this.requests | ? {$null -ne $_} | %{
            $request=$_
            if ($request.useChangeSet) {
                if ($currentChangeSet.Length -eq 0) {
                    $currentChangeSet="changeset_$([GUID]::NewGuid() | select -ExpandProperty guid)"
                    $this.body+="--$($this.batchID)"+"`r`n"
                    $this.body+='Content-Type: multipart/mixed; boundary="' + $currentChangeSet + '"'+"`r`n"
                    $this.body+="`r`n"
                    $this.body+="--$($currentChangeSet)"+"`r`n"
                } else {
                    $this.body+="--$($currentChangeSet)"+"`r`n"
                }
            } else {
                if ($currentChangeSet.Length -gt 0) {
                    $this.body+="--$($currentChangeSet)--"+"`r`n"
                    $this.body+="`r`n"
                    $currentChangeSet=""         
                }
                $this.body+="--$($this.batchID)"+"`r`n"
            }
            $this.body+="Content-Type: application/http"+"`r`n"
            $this.body+="Content-Transfer-Encoding: binary"+"`r`n"
            if ($currentChangeSet.Length -gt 0) {
                $this.body+="Content-ID: $($contentID)"+"`r`n"
            }
            $this.body+="`r`n"
            $this.body+=$request.render()
            $contentID+=1
        }
        if ($currentChangeSet.Length -gt 0) {
            $this.body+="--$($currentChangeSet)--"+"`r`n"
            $this.body+="`r`n"
            $currentChangeSet=""         
        }
        $this.body+="--$($this.batchID)--"+"`r`n"       
        $batchuri="$($envUri)/api/data/$($this.dvVersion)/`$batch"

        if ($null -eq $dvHeader) {
            $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
                @{"name"="OData-MaxVersion";"value"="4.0"},
                @{"name"="OData-Version";"value"="4.0"},
                @{"name"="Accept";"value"="application/json"}
            )
            if ($r.Success) {
                $batchHeader=$r.value
            }
        } else {
            $r=New-Result -success $true -message "Successfully retrieved header" -logLevel Information
            $batchHeader=$dvHeader
        }
        if ($null -eq $batchHeader) {
            $r=New-Result -success $false -message "Batchheader not retrievable" -logLevel Error
        }

        if ($r.Success) {
            try {
                $response=Invoke-WebRequest -Headers $batchHeader -Uri $batchuri -Body $this.body -Method "POST" -UseBasicParsing -ContentType $('multipart/mixed; charset=utf-8; boundary="' + $($this.batchID) + '"')
                #$response=Invoke-widWebRequest -Headers $batchHeader -Uri $batchuri -Body $this.body -Method "POST" -UseBasicParsing -ContentType $('multipart/mixed; charset=utf-8; boundary="' + $($this.batchID) + '"')
                $responseContent=[System.Text.Encoding]::UTF8.GetString($response.content)
                $responseParts=@()
                $responseBatchParts=@($responsecontent -split "--batchresponse_" | select -skip 1 | select -SkipLast 1) | ? {$null -ne $_}
                $responseBatchParts | %{
                    if ($_.IndexOf("--changesetresponse_") -gt 0) {
                        $responseParts+=@($_ -split "--changesetresponse_" | select -skip 1 | select -SkipLast 1) | ? {$null -ne $_}
                    } else {
                        $responseParts+=$_
                    }
                }
                $responseIndex=0
                $responseParts | %{
                    $singleResponse=$_
                    $dvResponse=[dvResponse]::new()
                    $dvResponse.request=$this.requests[$responseIndex]
                    $($singleResponse -split "`r`n") | %{
                        if ($_ -like "HTTP/1.1*") {$dvResponse.httpCode=$_.split(' ')[1]}
                        if ($_ -like "{*") {$dvResponse.dataObject=$_ | convertfrom-json;$dvResponse.data=$dvResponse.dataObject.value}
                        if ($_ -like "Location:*") {$dvResponse.location=$_.replace("Location: ","")}
                        if ($_ -like "Content-ID:*") {$dvResponse.location=$_.replace("Content-ID: ","")}
                        if ($_ -like "OData-EntityId:*") {$dvResponse.location=$_.replace("OData-EntityId: ","")}
                    }
                    $this.responses+=$dvResponse
                    $responseIndex+=1
                }

 <#
                responseBatchId=$responsecontent.substring(0,$responsecontent.IndexOf("`r`n"))
                $responseIndex=0
                @($responsecontent -split $responseBatchId | select -skip 1 | select -SkipLast 1) | ? {$null -ne $_} | %{
                    $singleResponse=$_
                    $dvResponse=[dvResponse]::new()
                    $dvResponse.request=$this.requests[$responseIndex]
                    $($singleResponse -split "`r`n") | %{
                        if ($_ -like "HTTP/1.1*") {$dvResponse.httpCode=$_.split(' ')[1]}
                        if ($_ -like "{*") {$dvResponse.dataObject=$_ | convertfrom-json;$dvResponse.data=$dvResponse.dataObject.value}
                        if ($_ -like "Location:*") {$dvResponse.location=$_.replace("Location: ","")}
                    }
                    $this.responses+=$dvResponse
                    $responseIndex+=1
                }
                $r=New-Result -success $true -message "Successfully ran DV batch" -value $this.responses -logLevel Information
 #>

                #$r=New-Result -success $true -message "Successfully ran DV batch" -value $responseContent -logLevel Information
                $r=New-Result -success $true -message "Successfully ran DV batch" -value $this.responses -logLevel Information
            } catch {
                $r=New-Result -success $false -message "Error running DV batch" -exception $($_.exception) -logLevel Error
            }
        }
        return $r
    }
}
function New-DvBatch() {
    param(
        $dvVersion="v9.2"
    )
    $dvBatch=[dvBatch]::new()
    $dvBatch
}
function Remove-DvData() {
    param(
        $envUri,
        $accessToken,
        $tableName,
        $primaryKey,
        $dvVersion="v9.2",
        [dvBatch]$dvBatch=$null,
        $useDvBatchChangeSet=$false
    )
    $qs="($($primaryKey))"
    $method="DELETE"
    $uri="$($envUri)/api/data/$($dvVersion)/$($tableName)$($qs)"
    if ($null -eq $dvBatch) {
        $r=Get-AuthHeader -accessToken $accessToken -additionalHeaderAttributes @(
            @{"name"="OData-MaxVersion";"value"="4.0"},
            @{"name"="OData-Version";"value"="4.0"},
            @{"name"="Prefer";"value"="return=representation"}
        )
        if ($r.Success) {
            $authHeader=$r.Value
            try {
                $response=Invoke-WebRequest -Headers $authHeader -Uri $uri -Method $method -UseBasicParsing
                #$response=Invoke-widWebRequest -Headers $authHeader -Uri $uri -Method $method -UseBasicParsing
                $r=New-Result -success $true -message "Successfully deleted record $($primaryKey) in table $tableName" -value $null
            } catch {
                $r=New-Result -success $false -message "Error deleting record $($primaryKey) in table $tableName" -exception $_.Exception
            }
        }
    } else {
        $r=$dvBatch.AddRequest($uri,$method,"application/json; charset=utf-8; type=entry",$body,$useDvBatchChangeSet)
    }        
    $r
}
function Test-IPInSubnet() {
    param(
        $ip,
        $subnetCIDR
    )
    try {
        $ipAddress=[System.Net.IPAddress]$ip
        [System.Net.IPAddress]$subnet=$subnetCIDR.split("/")[0]
        $subnetBytes=[int]$subnetCIDR.split("/")[1]
        [System.Net.IPAddress]$subnetMask = Convert-SubnetMask -SubnetMask $subnetBytes
        $subnet.Address -eq ($ipAddress.Address -band $subnetMask.Address)
    } catch {
        $false
    }
}
function Convert-SubnetMask() {
    param (
        $SubnetMask
    )
    if($SubnetMask -as [int]) {
        [ipaddress]$out = 0
        $out.Address = ([UInt32]::MaxValue) -shl (32 - $SubnetMask) -shr (32 - $SubnetMask)
        $out.IPAddressToString
    } elseif($SubnetMask = $SubnetMask -as [ipaddress]) {
        $SubnetMask.IPAddressToString.Split('.') | ForEach-Object {
            while(0 -ne $_){
                $_ = ($_ -shl 1) -band [byte]::MaxValue
                $result++
            }
        }
        $result -as [string]
    }
}
function New-httpResponse() {
    param(
        [System.Net.HttpStatusCode]$statusCode,
        $body,
        $headers=@{},
        [ValidateSet("text/plain; charset=utf-8","application/json; charset=utf-8")]$contentType
    )   
    @{
        StatusCode = $statusCode
        Body = $body
        Headers = $headers
        ContentType = $contentType
    }
}
function Test-Guid() {
    param(
        $guid
    )
    try {
        $null=[guid]$guid
        $true
    } catch {
        $false
    }
}
function New-RandomString() {
    param(
        $numBytes=64
    )
    $randomBytesArray = New-Object byte[] $numBytes
    $rngObject = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $rngObject.GetBytes($randomBytesArray)
    $randomString = [System.Convert]::ToBase64String($randomBytesArray)
    $randomString
}
function Get-ItemFromQueue() {
    param(
        $queueName
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
    #$response=Invoke-widWebRequest -Uri $url -Headers $headers -Method Get
    $q=[xml]$response.Content.Substring($response.Content.IndexOf("<QueueMessagesList>"))
    $message=$([System.Text.Encoding]::UTF8.GetString([convert]::FromBase64String($q.QueueMessagesList.QueueMessage.MessageText))) | convertfrom-json
    $message
}
