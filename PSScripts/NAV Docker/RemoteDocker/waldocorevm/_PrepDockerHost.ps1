
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

Install-RDHDependentModules `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption 