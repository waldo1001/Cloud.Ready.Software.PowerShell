. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'navserver'

Import-RDHTestToolkitToNavContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -ContainerSqlCredential $ContainerSqlCredential 
