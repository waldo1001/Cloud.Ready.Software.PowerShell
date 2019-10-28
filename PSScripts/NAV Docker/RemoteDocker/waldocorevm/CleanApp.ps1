
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcdaily'


<# Get-RDHCustomNAVApps `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containernamein 
 #>

Clean-RDHCustomNAVApps `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername 
