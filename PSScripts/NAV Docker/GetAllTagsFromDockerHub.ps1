$ResultingObject = @()

$result = Invoke-WebRequest -Uri "https://registry.hub.docker.com/v2/repositories/microsoft/dynamics-nav/tags/" 
$JsonObject = ConvertFrom-Json -InputObject $result.Content
$ResultingObject = $JsonObject.results
$ParentId = 1

while ($JsonObject.next) {
    $result = Invoke-WebRequest -Uri $JsonObject.next 
    $JsonObject = ConvertFrom-Json -InputObject $result.Content
    $ResultingObject += $JsonObject.results    
    
    $percCompleted = [Math]::Round($ResultingObject.Count / $JsonObject.count, 4) * 100
    Write-Progress -Activity "Processing tags" -PercentComplete $percCompleted -ParentId $ParentId 
}

break

$ResultingObject[0]
$ResultingObject.name
$ResultingObject | where name -like '*11.0.21063*' | select name
$ResultingObject.Count

$ResultingObject | where name -like '*be' | select name