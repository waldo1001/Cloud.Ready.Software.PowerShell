$RegistryName = "mcr.microsoft.com/businesscentral/sandbox"
$RegistryName = "mcr.microsoft.com/businesscentral/onprem"
$RegistryName = "bcinsider.azurecr.io/bcsandbox-master"
#$RegistryName = "bcinsider.azurecr.io/bcsandbox"
#$RegistryName = "bcinsider.azurecr.io/bconprem-master"
#$RegistryName = "bcinsider.azurecr.io/bconprem"

$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git
$user = $SecretSettings.containerRegistryUserName
$pass = $SecretSettings.containerRegistryPassword

$Tags = @()
$NextRequestUrl = ('https://{0}/v2/{1}/tags/list?n=999' -f ([regex]::Match($RegistryName, '^([\w.]*)/(.*)').Groups[1].Value), ([regex]::Match($RegistryName, '^([\w.]*)/(.*)').Groups[2].Value)) 
while ($NextRequestUrl) {
    $result = Invoke-WebRequest -Uri $NextRequestUrl -Method get -Headers @{
        Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)")))"
    } 
    $Tags += (ConvertFrom-Json -InputObject $result.Content).Tags

    if ($result.Headers.Link) {
        $NextRequestUrl = "https://" + ([regex]::Match($RegistryName, '^([\w.]*)/(.*)').Groups[1].Value) + [regex]::Match($result.Headers.Link, '<(.+)>').Groups[1].Value
    }
    else {
        $NextRequestUrl = ""
    }
}

break
$tags                                      #All Tags
$tags.count                                #Number of Tags
$tags | Where-Object {$_ -like "*be*"}            #All Belgian images
$tags | Where-Object {$_ -like '*ltsc2019*'}      #All ltsc2019 images
