. '.\_Settings.ps1'

New-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $ContainerName `
    -ContainerDockerImage $ContainerImage `
    -ContainerLicenseFile $ContainerLicenseFile `
    -ContainerAdditionalParameters @("--network=tlan","--ip $ContainerIP") `
    -ContainerMemory 3G `
    -ContainerCredential $ContainerCredentials `
    -ContainerAlwaysPull 

Install-RDHDependentModules `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $ContainerName