. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcsandbox'

$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/sandbox:dk'

#$SecretSettings.containerLicenseFile = "$env:USERPROFILE\Dropbox (Personal)\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_2019 04 08.flf"

$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestToolkit = $true
$includeTestLibrariesOnly = $true

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
    -enableSymbolLoading:$enableSymbolLoading `
    -assignPremiumPlan:$assignPremiumPlan `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -Verbose `
    -memoryLimit 8G `
    -accept_outdated `
    -includeAL