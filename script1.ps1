param(
    $environment
)

$environment
$(get-date) | Out-File "$($env:TEMP)\text.txt"
