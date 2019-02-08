. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$containerName = 'bconprem'
$Path = 'C:\Temp\JCD'
$filter = 'Type=3;Id=1306'

$result = Export-RDHNAVApplicationObjectsAsAL `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $containerName `
    -Path $Path `
    -filter $filter

start $result
