. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'microsoft/dynamics-nav:devpreview-finbe'
$Containername = 'navserver'
$ContainerAdditionalParameters += "--ip 172.21.31.3"

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
    -ContainerLicenseFile "https://www.dropbox.com/s/ustqbztx5reznzx/5230132_003%20and%20004%20IFACTO_NAV2018_BELGIUM_2017%2012%2001.flf?dl=1" `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$false `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText 
