param(
    $environment
)

Write-Host "Hello"
Write-Host $env:environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"
