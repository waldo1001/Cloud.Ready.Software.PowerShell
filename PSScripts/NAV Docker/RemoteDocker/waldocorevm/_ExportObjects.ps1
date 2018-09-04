. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'navserver'

Export-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Path 'C:\Temp\' `
    -filter 'Id=459'

