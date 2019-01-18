$Registry = "https://mcr.microsoft.com/v2/businesscentral/sandbox/tags/list"
$Registry = "https://mcr.microsoft.com/v2/businesscentral/onprem/tags/list"

$result = Invoke-WebRequest -Uri $Registry 
$JsonObject = ConvertFrom-Json -InputObject $result.Content
$tags = $JsonObject.tags

$tags                                      #All Tags
$tags | where {$_ -like "*be*"}            #All Belgian images
$tags | where {$_ -like '*ltsc2019*'}      #All ltsc2019 images

