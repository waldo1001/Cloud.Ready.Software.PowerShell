#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$DockerHost = 'waldocorevm'
$DockerHostUseSSL = $false
$DockerHostSessionOption = New-PSSessionOption

$UserName = 'administrator'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerDockerImage = 'microsoft/dynamics-nav:devpreview'
$Containername = 'psdevenv'
$ContainerLicenseFile = $SecretSettings.containerLicenseFile
$ContainerAdditionalParameters = @("--network=tlan")
$ContainerAdditionalParameters += "--ip 172.21.31.6"

#Just to update the modules to my local latest uncommitted version to be able to test them
import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force -WarningAction SilentlyContinue
