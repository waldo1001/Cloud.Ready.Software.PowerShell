$artifactUrl = "https://bcartifacts.azureedge.net/onprem/"
$imageName = "waldo:something"

if (-not (Get-BcContainerGenericTag -containerOrImageName $imageName -ErrorAction SilentlyContinue)) {
    New-Bcimage -artifactUrl $artifactUrl -imageName $imagename
}
