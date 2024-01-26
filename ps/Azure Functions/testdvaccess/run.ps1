param($Timer)

try {
    Import-Module widtools -WarningAction SilentlyContinue
    Import-Module widup -WarningAction SilentlyContinue
    Initialize-WIDUp

    #$credential=New-Object -TypeName pscredential -ArgumentList "TESTWID\vmadmin",("HgtreBfT564UZ#hzuG" | ConvertTo-SecureString -AsPlainText -Force)
    #$session=New-PSSession -UseSSL -ComputerName "vmhofbaddststsn" -Port 5986 -Credential $credential -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)

    #Invoke-Command -Session $session -ScriptBlock {
    #    get-aduser -Credential $using:credential | ft samaccountname,userprincipalname | out-string
    #}


    $userrecord='{
        "@odata.etag":  "W/\"JzE5OzE1NTg3NTU3OTMzMDgxMzU5NDkxOzAwOyc=\"",
        "systemId":  "fe88afd1-6a00-ee11-8f6e-002248f3a2c8",
        "employeeNo":  "466",
        "name":  "M?ller",
        "firstName":  "Pascal",
        "businessEMail":  "pascal.mueller@wagner.ch",
        "id":  "MUEP",
        "department":  "7200",
        "systemCreatedAt":  "2023-06-01T10:55:29.99Z",
        "systemCreatedBy":  "4f824d58-bccb-4fc8-8a12-36c4619cbc8a",
        "systemModifiedAt":  "2023-09-29T09:02:38.23Z",
        "systemModifiedBy":  "1bcdfeec-acb2-4c86-a09e-2b5ba030a3d5"
    }' | ConvertFrom-Json
    
    $r=Get-wupVaultSecret -secretName $global:adusernamekvsecretname -vaultUrl $global:vaultUrl | Write-Result
    if ($r.Success) {    
        $ADUserName=$r.Value.Value
        $r=Get-wupVaultSecret -secretName $global:aduserpasswordkvsecretname -vaultUrl $global:vaultUrl | Write-Result
    }
    if ($r.Success) {
        $ADUserPassword=$r.Value.value
        $credential=New-Object -TypeName pscredential -ArgumentList $ADUserName,($ADUserPassword | ConvertTo-SecureString -AsPlainText -Force)
        $r=Get-wupADServerSession -credential $credential | Write-Result
    }
    if ($r.Success) {
        $session=$r.Value
        $r=Invoke-wupADServerCommand -userrecord $userrecord -credential $credential -session $session | Write-Result
    }
    
    
} catch {

    $($_.exception.message)
}