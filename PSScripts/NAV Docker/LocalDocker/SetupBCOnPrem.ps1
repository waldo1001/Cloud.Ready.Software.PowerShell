. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bconprem'

#$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:base'
$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:be'
#$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:cu3-ltsc2019'


#$SecretSettings.containerLicenseFile = "$env:USERPROFILE\Dropbox (Personal)\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_2019 04 08.flf"

$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestToolkit = $false
$includeTestLibrariesOnly = $true
$InstallDependentModules = $true

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
    -memoryLimit 4G `
    -accept_outdated

break

if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}

Sync-NCHNAVTenant -containerName $ContainerName
