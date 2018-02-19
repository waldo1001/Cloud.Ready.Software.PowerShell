. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'microsoft/dynamics-nav:devpreview-be'
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
    -ContainerName $Containername `
    -ContainerLicenseFile $ContainerLicenseFile `
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