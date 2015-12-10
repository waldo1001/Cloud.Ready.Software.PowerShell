. (join-path $PSScriptRoot 'Set-UpgradeSettings.ps1')

$UpgradedServerInstance | Remove-NAVEnvironment 
