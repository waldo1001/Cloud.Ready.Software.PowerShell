. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcdaily'

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master'
# $ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox:be-ltsc2019'

#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master:14.0.28630.0-al'
$SecretSettings.containerLicenseFile = 'C:\Users\ericw\Dropbox\Dynamics NAV\Licenses\5230132_iFACTO_D365 BUSINESS CENTRAL ON PREMISES_VERSION14_2019 08 29.flf'

$registry = $ContainerDockerImage.Substring(0, $ContainerDockerImage.IndexOf('/'))
docker login "$registry" -u "$($SecretSettings.containerRegistryUserName)" -p "$($SecretSettings.containerRegistryPassword)"

$ContainerAlwaysPull = $false
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestLibrariesOnly = $false
$includeTestToolkit = $false
$InstallDependentModules = $false

# -isolation 'HyperV'
# Write-Host "New-NavContainer 
# -containerName '$ContainerName' 
# -imageName '$ContainerDockerImage' 
# -accept_eula 
# -additionalParameters '$ContainerAdditionalParameters' 
# -alwaysPull:'$ContainerAlwaysPull' 
# -Credential '$ContainerCredential' 
# -updateHosts 
# -auth NavUserPassword 
# -enableSymbolLoading:$enableSymbolLoading 
# -assignPremiumPlan:$assignPremiumPlan 
# -useBestContainerOS 
# -includeTestToolkit:$includeTestToolkit 
# -includeTestLibrariesOnly:$includeTestLibrariesOnly 
# -Verbose 
# -memoryLimit 8G 
# -accept_outdated 
# -includeAL 
# -shortcuts 'None' #'None' for no shortcuts (or 'Desktop') "


# -isolation 'HyperV' `
New-NavContainer `
    -containerName $ContainerName `
    -imageName $ContainerDockerImage `
    -accept_eula `
    -additionalParameters $ContainerAdditionalParameters `
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
    -myscripts @( @{ "SetupVariables.ps1" = 'if (Get-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" | Select-Object -ExpandProperty "ServicesPipeTimeout" -ErrorAction SilentlyContinue) {
            Write-host "ServicesPipeTimeout already set"
    $restartingInstance = $false
    $newPublicDnsName = $true
    . "c:\run\SetupVariables.ps1"
}
else {
    Write-host "Set ServicesPipeTimeout and restart"
    Set-ItemProperty -Path "HKLM:\system\CurrentControlSet\control" -name "ServicesPipeTimeout" -Value 2000000 -Type DWORD -Force
    Restart-computer
    Start-Sleep -seconds 10000
}' 
    }) `
    
    
    

# -licenseFile $SecretSettings.containerLicenseFile `
if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}
    
# New-NavContainer `
#     -imageName $ContainerDockerImage `
#     -accept_eula