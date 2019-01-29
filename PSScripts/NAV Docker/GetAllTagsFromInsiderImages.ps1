$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$BaseUrl = "https://bcinsider.azurecr.io"
$Registry = "$BaseUrl/v2/bconprem/tags/list"             #Next OnPrem
#$Registry = "$BaseUrl/v2/bcsandbox/tags/list"            #Next SaaS
#$Registry = "$BaseUrl/v2/bconprem-master/tags/list"      #Daily build OnPrem (Next major)
$Registry = "$BaseUrl/v2/bcsandbox-master/tags/list"     #Daily build SaaS (Next major)

$user = $SecretSettings.containerRegistryUserName
$pass = $SecretSettings.containerRegistryPassword

$result = Invoke-WebRequest -Uri $Registry -Method get -Headers @{
    Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)")))"
} 
$JsonObject = ConvertFrom-Json -InputObject $result.Content
$Tags = $JsonObject.tags

while ($result.Headers.Link) {
    $nextURI = $BaseUrl + [regex]::Match($result.Headers.Link, '<(.+)>').Groups[1].Value

    $result = Invoke-WebRequest -Uri $nextURI -Method get -Headers @{
        Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)")))"
    } 
    $JsonObject = ConvertFrom-Json -InputObject $result.Content
    $Tags += $JsonObject.tags        
}

break
$tags                                      #All Tags
$tags.count                                #Number of Tags
$tags | where {$_ -like "*be*"}            #All Belgian images
$tags | where {$_ -like '*ltsc2019*'}      #All ltsc2019 images
