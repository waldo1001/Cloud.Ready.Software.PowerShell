. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'navinsider.azurecr.io/dynamics-nav:11.0.20977.0-finus'
$ContainerRegistryUserName = $SecretSettings.containerRegistryUserName
$ContainerRegistryPwd = $SecretSettings.containerRegistryPassword

$Containername = 'devpreview'
$ContainerAdditionalParameters += "--ip 172.21.31.4"

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

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
    -ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText 

New-RDHNAVSuperUser `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Username 'waldo2' `
    -Password (ConvertTo-SecureString 'waldo1234' -AsPlainText -Force) `
    -CreateWebServicesKey