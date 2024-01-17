param(
    $environment
)

Write-Host $environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"
