param(
    [ValidateSet('debitor','jobhead','jobtask','jobplanningline','employee')]$jobRecordType,
    [ValidateSet('delta','full')]$jobSyncType="delta",
    [bool]$jobRunSingle=$true
)
$functionKeys=Get-FunctionKeys
$headers=[hashtable]@{
    "x-functions-key"="$($functionkeys.systemKey.value)"
}
$body=[PSCustomObject]@{
    jobRecordType = $jobRecordType
    jobSyncType = $jobSyncType
    jobRunSingle = $jobRunSingle
} | ConvertTo-Json
try {
    $response=Invoke-WebRequest -Uri "$($global:apiBaseUrl)api/system/startjob" -Method Post -Body $body -Headers $headers -ContentType "application/json; charset=utf-8" -UseBasicParsing
    $response.StatusCode
    $response.Content | convertfrom-json
} catch {
    $_.exception.message
    $_.Exception.Response.GetResponseStream().position=0
    $(New-object System.IO.StreamReader($_.Exception.Response.GetResponseStream())).ReadToEnd()
}
