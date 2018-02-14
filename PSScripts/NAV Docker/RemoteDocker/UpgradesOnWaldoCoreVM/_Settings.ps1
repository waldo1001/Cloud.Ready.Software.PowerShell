#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

#In one Dictionary, to be able to easily pass it to remote servers
$UpgradeSettings = @{}

#General
$UpgradeSettings.UpgradeName = 'VARO'

$UpgradeSettings.OriginalVersion = 'Distri81' 
$UpgradeSettings.ModifiedVersion = 'VARO2013R2'
$UpgradeSettings.TargetVersion = 'Distri110'

$UpgradeSettings.LocalOriginalFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.OriginalVersion).zip"
$UpgradeSettings.LocalModifiedFile = $null
$UpgradeSettings.LocalTargetFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.TargetVersion).zip"

$UpgradeSettings.VersionListPrefixes = 'NAVW1', 'NAVBE', 'I'
$UpgradeSettings.AvoidConflictsForLanguages = 'NLB','FRB','ENU','ESP'

#Semi-fixed settings (scope within container)
$UpgradeSettings.UpgradeFolder = 'C:\ProgramData\NavContainerHelper\Upgrades' #locally in the container
$UpgradeSettings.ObjectLibrary = Join-Path $UpgradeSettings.UpgradeFolder '_ObjectLibrary'
$UpgradeSettings.ResultFolder = Join-Path $UpgradeSettings.UpgradeFolder "$($UpgradeSettings.UpgradeName)_Result"

$UpgradeSettings.OriginalObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.OriginalVersion).txt"
$UpgradeSettings.ModifiedObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.ModifiedVersion).txt"
$UpgradeSettings.TargetObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.TargetVersion).txt"

#Docker Settings
$DockerHost = 'WaldoCoreVM'
$DockerHostShare = "c:\ProgramData\NavContainerHelper"
$UserName = 'administrator'
$Password = ConvertTo-SecureString $SecretSettings.password -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
$DockerHostSessionOption = New-PSSessionOption
$DockerHostUseSSL = $false

#ContainerSettings
$ContainerName = 'Upgrade'
$ContainerUserName = 'waldo'
$ContainerPassword = ConvertTo-SecureString 'waldo1234' -AsPlainText -Force
$ContainerCredentials = New-Object System.Management.Automation.PSCredential ($ContainerUserName, $ContainerPassword)
$ContainerImage = 'microsoft/dynamics-nav:devpreview' 
$ContainerIP = '172.21.31.19'
$ContainerLicenseFile = $SecretSettings.containerLicenseFile

$HostFile = 'C:\Windows\System32\drivers\etc\hosts'

#Just to update the modules to my local latest uncommitted version to be able to test them
import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force 
