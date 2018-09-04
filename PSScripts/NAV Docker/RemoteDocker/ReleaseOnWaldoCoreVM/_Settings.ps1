#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

#In one Dictionary, to be able to easily pass it to remote servers
$ReleaseSettings = @{}

#Docker Settings
$DockerHost = 'WaldoCoreVM'
$DockerHostShare = "c:\ProgramData\NavContainerHelper"
$UserName = 'administrator'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
$DockerHostSessionOption = New-PSSessionOption
$DockerHostUseSSL = $false

#ContainerSettings
$ContainerName = 'psdevenv'
$ContainerUserName = 'waldo'
$ContainerPassword = ConvertTo-SecureString 'waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($ContainerUserName, $ContainerPassword)
$ContainerImage = 'microsoft/bcsandbox' 
$ContainerLicenseFile = $SecretSettings.containerLicenseFile
$ContainerAdditionalParameters = @("--network=tlan")
$ContainerAdditionalParameters += "--ip 172.21.31.6"

$HostFile = 'C:\Windows\System32\drivers\etc\hosts'

#Just to update the modules to my local latest uncommitted version to be able to test them
import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force 
