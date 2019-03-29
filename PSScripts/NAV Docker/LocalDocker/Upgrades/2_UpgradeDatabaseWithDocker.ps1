. '.\_Settings.ps1'

start $UpgradeSettings.UpgradeFolder

chcp 850 

Merge-NCHNAVApplicationObjects `
    -ContainerName $ContainerName `
    -UpgradeSettings $UpgradeSettings