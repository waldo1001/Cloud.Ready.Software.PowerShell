. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'devpreview'
$ContainerAdditionalParameters += "--ip 172.21.31.4"

$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master:base'
$ContainerAlwaysPull = $true
$enableSymbolLoading = $true

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
    