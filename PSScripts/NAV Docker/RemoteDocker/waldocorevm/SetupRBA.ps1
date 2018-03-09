. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'microsoft/dynamics-nav:devpreview-finus'
$Containername = 'RBA'
$ContainerAdditionalParameters += "--ip 172.21.31.8"
$containerLicenseFile = 'https://www.dropbox.com/s/15su7b9fwi6wi4h/RBA.flf?dl=1'

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
    -ContainerLicenseFile $containerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$false `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText 
