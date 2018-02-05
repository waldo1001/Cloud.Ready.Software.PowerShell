. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerDockerImage = 'microsoft/dynamics-nav:devpreview'
$Containername = 'devpreview'

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

New-NAVContainerOnDockerHost `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerDockerImage $ContainerDockerImage `
    -ContainerName $Containername `
    -ContainerLicenseFile $ContainerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters