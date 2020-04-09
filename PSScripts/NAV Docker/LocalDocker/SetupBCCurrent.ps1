. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bccurrent'

$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem:be-ltsc2019'
# $ContainerDockerImage = 'microsoft/dynamics-nav:2018-cu9-fr'

#$SecretSettings.containerLicenseFile = 'C:\Users\ericw\Dropbox\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_VERSION14_2019 08 29.flf'
$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$InstallDependentModules = $false

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
    -includeAL `
    # -useBestContainerOS
#     -myscripts @( @{ "SetupVariables.ps1" = 'if (Get-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" | Select-Object -ExpandProperty "ServicesPipeTimeout" -ErrorAction SilentlyContinue) {
#         Write-host "ServicesPipeTimeout already set"
#         $restartingInstance = $false
#         $newPublicDnsName = $true
#         . "c:\run\SetupVariables.ps1"
#     }
#     else {
#         Write-host "Set ServicesPipeTimeout and restart"
#         Set-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" -name "ServicesPipeTimeout" -Value 2000000 -Type DWORD -Force
#         Restart-computer
#         Start-Sleep -seconds 10000
#     }' 
# })

# -useBestContainerOS `
    

if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}

