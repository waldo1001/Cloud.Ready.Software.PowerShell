. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcnext'

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox:be'
$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $true
$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
$InstallDependentModules = $true


$registry = $ContainerDockerImage.Substring(0, $ContainerDockerImage.IndexOf('/'))
Write-Host -ForegroundColor Gray "Connecting docker to $registry user: $($SecretSettings.containerRegistryUserName) pwd: $($SecretSettings.containerRegistryPassword)"
docker login "$registry" -u "$($SecretSettings.containerRegistryUserName)" -p "$($SecretSettings.containerRegistryPassword)"


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
    -Verbose


if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}

Sync-NCHNAVTenant -containerName $ContainerName