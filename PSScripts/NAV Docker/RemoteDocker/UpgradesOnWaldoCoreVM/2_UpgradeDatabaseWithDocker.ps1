. '.\_Settings.ps1'

Start "\\172.21.31.2\NavContainerHelper"

Merge-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $ContainerName `
    -UpgradeSettings $UpgradeSettings
