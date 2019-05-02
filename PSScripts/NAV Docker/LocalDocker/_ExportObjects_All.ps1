. (Join-Path $PSScriptRoot '.\_Settings.ps1')


$ObjectsFolder = "C:\temp"
$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/sandbox'

#Fixed params
$Containername = 'temponly'
$ContainerAlwaysPull = $true

$ExportTo = "$env:USERPROFILE\Dropbox (Personal)\Dynamics NAV\ObjectLibrary\"

New-NavContainer `
    -containerName $ContainerName `
    -imageName $ContainerDockerImage `
    -accept_eula `
    -additionalParameters $ContainerAdditionalParameters `
    -licenseFile $SecretSettings.containerLicenseFile `
    -alwaysPull:$ContainerAlwaysPull `
    -Credential $ContainerCredential `
    -doNotExportObjectsToText `
    -updateHosts `
    -auth NavUserPassword `
    -includeCSide `
    -enableSymbolLoading:$enableSymbolLoading `
    -assignPremiumPlan:$assignPremiumPlan `
    -useBestContainerOS `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -Verbose `
    -memoryLimit 4G

$ObjectFile =
    Export-NCHNAVApplicationObjects -ContainerName $Containername

$ZippedFileName = Join-Path $ObjectFile.Directory "$($ObjectFile.BaseName).zip"
Compress-Archive -Path $ObjectFile -DestinationPath $ZippedFileName -Force

if (Copy-Item -Path $ZippedFileName -Destination $ExportTo -Force){
    Remove-Item $ObjectFile -ErrorAction SilentlyContinue
    Start-Process $ExportTo
}

Remove-NavContainer -containerName $Containername

