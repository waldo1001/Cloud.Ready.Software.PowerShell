#Example of settings for when your dockerhost is installed on a local VM

$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$DockerHost = 'waldocorevm'
$DockerHostUseSSL = $false
$DockerHostSessionOption = New-PSSessionOption

$UserName = 'administrator'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerLicenseFile = $SecretSettings.containerLicenseFile
$ContainerAdditionalParameters = @("--network=tlan","--ip 172.21.31.4")

