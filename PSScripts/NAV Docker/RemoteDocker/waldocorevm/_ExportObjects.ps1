. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bconprem'
$Path = 'C:\Temp\'
$filter = ''

Export-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Path $Path `
    -filter $filter

Start $Path
