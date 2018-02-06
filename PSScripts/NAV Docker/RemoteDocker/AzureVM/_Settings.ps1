#Example of settings for Azure VM

$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$DockerHost = 'waldops.westeurope.cloudapp.azure.com'
$DockerHostUseSSL = $true
$DockerHostSessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$UserName = 'vmadmin'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerLicenseFile = $SecretSettings.containerLicenseFile
$ContainerAdditionalParameters = @()
