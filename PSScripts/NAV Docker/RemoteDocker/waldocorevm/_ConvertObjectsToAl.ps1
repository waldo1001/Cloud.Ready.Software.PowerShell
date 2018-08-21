. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$containerName = 'devpreview'
$Path = 'C:\Temp\Reports'

$result = Export-RDHNAVApplicationObjectsAsAL `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $containerName `
    -Path $Path `
    -extensionStartId 50000 `
    -filter 'Type=3'  #All Reports

start $result
