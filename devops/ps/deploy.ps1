Write-Host "ps deploy"
Write-Host $env:environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"