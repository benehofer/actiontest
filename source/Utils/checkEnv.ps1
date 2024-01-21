param(

)
#check bc queue
function Get-QueueInfo() {
    param(
        $headers,
        $queuename
    )
    $url="$($global:QueueStorageUri)$($queuename)/messages?peekonly=true&numofmessages=32"
    try {
        $response=Invoke-WebRequest -Uri $url -Headers $headers -Method Get
        $queueInfo=[xml]$response.Content.Substring(3)
        $queueInfo | Add-Member -MemberType NoteProperty -Name "numMessages" -Value $($queueInfo.QueueMessagesList.ChildNodes.Count)
        $queueInfo | Add-Member -MemberType NoteProperty -Name "queuename" -Value $($queuename)
        $queueInfo | Add-Member -MemberType NoteProperty -Name "queueOk" -Value $($queueInfo.numMessages -eq 0)   
        $queueInfo
    } catch {
        $null
    }
}
#check queues
$r=Get-accessToken -resourceURI $global:QueueStorageUri  
$headers=@{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $r.Value
    'Accept' = 'text/xml'
    'x-ms-version'='2017-11-09'
}
$allQueues=@()
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:jobQueueName)"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:jobQueueName)-poison"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:bcQueueName)"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:bcQueueName)-poison"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:snowQueueName)"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:snowQueueName)-poison"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:dvQueueName)"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:dvQueueName)-poison"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:adQueueName)"
$allQueues+=Get-QueueInfo -headers $headers -queuename "$($global:adQueueName)-poison"

#check jobs
$r=Get-AuthHeader -resourceURI $Global:tableStorageUri -additionalHeaderAttributes @{
    'Accept' = 'application/json;odata=nometadata'
    'x-ms-version'='2017-11-09'
}
$headers=$r.value
$url="$($Global:tableStorageUri)$($global:syncjobtablename)"
$response=Invoke-WebRequest -Uri $url -Headers $headers -Method Get -UseBasicParsing
$rows=($response.Content | ConvertFrom-Json) | select -ExpandProperty value
#"All jobs"
$rows | sort rowkey | select recordtype,@{"name"="last delta sync";expression={get-date $_.lastdeltasyncat -Format "s"}},@{"name"="last full sync";expression={get-date $_.lastfullsyncat -Format "s"}} | ft
#"Jobs running"
$rows | ? {$_.queuedat -ne $null} | select recordtype,sourcetype,destinationtype,queuedat | ft
$allQueues | select queuename,queueok,numMessages | ft
