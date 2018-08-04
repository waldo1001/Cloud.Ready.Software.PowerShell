. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox'
$ContainerAlwaysPull = $true
$SecretSettings.containerLicenseFile = "c:\programdata\navcontainerhelper\NAV2018License.flf"

$ContainerRegistryUserName = $SecretSettings.containerRegistryUserName
$ContainerRegistryPwd = $SecretSettings.containerRegistryPassword

$Containername = 'devpreview'
$ContainerAdditionalParameters += "--ip 172.21.31.4"

<# 
part of settings (or should be at least)

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
 #>

New-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerDockerImage $ContainerDockerImage `
    -ContainerRegistryUserName $ContainerRegistryUserName `
    -ContainerRegistryPwd $ContainerRegistryPwd `
    -ContainerName $Containername `
    -ContainerLicenseFile $SecretSettings.containerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText