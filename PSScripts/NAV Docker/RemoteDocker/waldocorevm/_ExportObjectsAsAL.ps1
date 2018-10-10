. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$containerName = 'devpreview'
$Path = 'C:\Temp\DirectionsNA'
$filter = 'Type=3;Id=1..100'

$result = Export-RDHNAVApplicationObjectsAsAL `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $containerName `
    -Path $Path `
    -filter $filter

start $result
