. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcaldep'

$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:be'

#$SecretSettings.containerLicenseFile = 'C:\Users\ericw\Dropbox\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_VERSION14_2019 08 29.flf'

$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $true
$includeTestToolkit = $true
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