param(
    $environment
)

Write-Host "Hello"
Write-Host $environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"
