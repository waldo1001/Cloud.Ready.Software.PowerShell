. '.\_Settings.ps1'

Start "\\172.21.31.2\NavContainerHelper"

Merge-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -ContainerName $ContainerName `
    -UpgradeSettings $UpgradeSettings
