. (Join-Path $PSScriptRoot '.\_Settings.ps1')

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
    -ContainerAdditionalParameters $ContainerAdditionalParameters `    -donotexportobjects
