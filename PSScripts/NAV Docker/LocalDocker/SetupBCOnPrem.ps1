. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bconprem'

$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:14.9.39327.0-w1'
# $ContainerDockerImage = 'mcr.microsoft.com/businesscentral/sandbox'
#$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:cu3-ltsc2019'


#$SecretSettings.containerLicenseFile = "$env:USERPROFILE\Dropbox (Personal)\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_2019 04 08.flf"

$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
$InstallDependentModules = $false

New-NavContainer `
    -containerName $ContainerName `
    -imageName $ContainerDockerImage `
    -accept_eula `
    -additionalParameters $ContainerAdditionalParameters `
    -licenseFile $SecretSettings.containerLicenseFile `
    -alwaysPull:$ContainerAlwaysPull `
    -Credential $ContainerCredential `
    -updateHosts `
    -auth NavUserPassword `
    -enableSymbolLoading:$enableSymbolLoading `
    -assignPremiumPlan:$assignPremiumPlan `
    -useBestContainerOS `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -Verbose `
    -memoryLimit 8G `
    -accept_outdated `
    -includeAL `
    -shortcuts 'None' #'None' for no shortcuts (or 'Desktop') `


if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}
