. '.\_Settings.ps1'

Merge-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -ContainerName $ContainerName `
    -UpgradeSettings $UpgradeSettings

Start "\\172.21.31.2\NavContainerHelper"