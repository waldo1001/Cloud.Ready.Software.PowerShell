#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

#In one Dictionary, to be able to easily pass it to remote servers
$ReleaseSettings = @{}

#ContainerSettings
$ContainerName = 'Upgrade'
$ContainerUserName = 'waldo'
$ContainerPassword = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredentials = New-Object System.Management.Automation.PSCredential ($ContainerUserName, $ContainerPassword)
$ContainerImage = 'mcr.microsoft.com/businesscentral/onprem:be' 
$ContainerLicenseFile = $SecretSettings.containerLicenseFile
$ContainerAdditionalParameters = @("--env isBcSandbox=Y", "--cpu-count 8", "--dns=8.8.8.8")
