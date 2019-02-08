. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcnext'
$ContainerAdditionalParameters += "--ip 172.21.31.15"

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox:us'
$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
#$SecretSettings.containerLicenseFile = 'c:\programdata\navcontainerhelper\NAV2018License.flf'


New-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerDockerImage $ContainerDockerImage `
    -ContainerRegistryUserName $SecretSettings.containerRegistryUserName `
    -ContainerRegistryPwd $SecretSettings.containerRegistryPassword `
    -ContainerName $Containername `
    -ContainerLicenseFile $SecretSettings.containerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText `
    -enableSymbolLoading:$enableSymbolLoading
    