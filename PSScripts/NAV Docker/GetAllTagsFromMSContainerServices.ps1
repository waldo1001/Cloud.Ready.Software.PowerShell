# $Registry = "https://mcr.microsoft.com/v2/businesscentral/sandbox/tags/list"
$Registry = "https://mcr.microsoft.com/v2/businesscentral/onprem/tags/list"
#$Registry = "https://mcr.microsoft.com/v2/dynamics-nav/tags/list"

$result = Invoke-WebRequest -Uri $Registry 
$JsonObject = ConvertFrom-Json -InputObject $result.Content
$tags = $JsonObject.tags
break
$tags                                      #All Tags
$tags.count                                #Number of Tags
$tags | where {$_ -like "*be*"}            #All Belgian images
$tags | where {$_ -like '*ltsc2019*'}      #All ltsc2019 images

