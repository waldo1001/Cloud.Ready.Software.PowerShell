. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcdaily'

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master:base'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master:14.0.28630.0-al'

$registry = $ContainerDockerImage.Substring(0, $ContainerDockerImage.IndexOf('/'))
Write-Host -ForegroundColor Gray "Connecting docker to $registry user: $($SecretSettings.containerRegistryUserName) pwd: $($SecretSettings.containerRegistryPassword)"
docker login "$registry" -u "$($SecretSettings.containerRegistryUserName)" -p "$($SecretSettings.containerRegistryPassword)"

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
    -accept_outdated `
    -includeAL 
# -clickonce 
#  -myScripts @("https://raw.githubusercontent.com/Microsoft/nav-docker/master/generic/Run/SetupConfiguration.ps1") `

if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly    
}

    