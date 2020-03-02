. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcnext'

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox:be'
$ContainerDockerImage = 'bcinsider.azurecr.io/bconprem'
$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $true
$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
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
    -enableSymbolLoading:$enableSymbolLoading `
    -assignPremiumPlan:$assignPremiumPlan `
    -useBestContainerOS `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -Verbose `
    -includeAL 
# -myscripts @( @{ "SetupVariables.ps1" = 'if (Get-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" | Select-Object -ExpandProperty "ServicesPipeTimeout" -ErrorAction SilentlyContinue) {
#     Write-host "ServicesPipeTimeout already set"
#     $restartingInstance = $false
#     $newPublicDnsName = $true
#     . "c:\run\SetupVariables.ps1"
# }
# else {
#     Write-host "Set ServicesPipeTimeout and restart"
#     Set-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" -name "ServicesPipeTimeout" -Value 2000000 -Type DWORD -Force
#     Restart-computer
#     Start-Sleep -seconds 10000
# }' 
# }) `


# if ($InstallDependentModules) {
#     Install-NCHDependentModules `
#         -ContainerName $ContainerName `
#         -ContainerModulesOnly
# }

# Sync-NCHNAVTenant -containerName $ContainerName
