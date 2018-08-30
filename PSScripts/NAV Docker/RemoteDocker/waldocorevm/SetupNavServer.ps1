. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'navserver'
$ContainerAdditionalParameters += "--ip 172.21.31.3"

$ContainerDockerImage = 'microsoft/bcsandbox:base'
$ContainerAlwaysPull = $true

New-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerDockerImage $ContainerDockerImage `
    -ContainerName $Containername `
    -ContainerLicenseFile $SecretSettings.containerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText