Write-Host "iac deploy"
Write-Host $env:environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"
Start-Sleep -Seconds 5