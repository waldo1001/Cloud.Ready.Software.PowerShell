. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'nav2018'

Export-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Path 'C:\Temp\'
