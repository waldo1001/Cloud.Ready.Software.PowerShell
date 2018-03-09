#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$DockerHost = 'waldocorevm'
$DockerHostUseSSL = $false
$DockerHostSessionOption = New-PSSessionOption

$UserName = 'administrator'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerAdditionalParameters = @("--network=tlan")


#Just to update the modules to my local latest uncommitted version to be able to test them
import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force -WarningAction SilentlyContinue
