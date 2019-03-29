#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

#In one Dictionary, to be able to easily pass it to remote servers
$UpgradeSettings = @{}

#General
$UpgradeSettings.UpgradeName = 'DistriCU3'

$UpgradeSettings.OriginalVersion = '13.1.25924.0-be' 
$UpgradeSettings.ModifiedVersion = 'Distri131BCDEV'
$UpgradeSettings.TargetVersion = '13.3.27183.0-be'

$UpgradeSettings.LocalOriginalFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.OriginalVersion).zip"
$UpgradeSettings.LocalModifiedFile = "C:\temp\DistriCU3\Distri131BCDEV.txt" #"$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.ModifiedVersion).zip"
$UpgradeSettings.LocalTargetFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.TargetVersion).zip" 

#$UpgradeSettings.VersionListPrefixes = 'NAVW1', 'NAVBE', 'Test', 'SI', 'IB', 'IF'     #Food
$UpgradeSettings.VersionListPrefixes = 'NAVW1', 'NAVBE', 'Test', 'I'                 #Distri
$UpgradeSettings.AvoidConflictsForLanguages = $null #'NLB', 'FRB', 'ENU', 'NLD'

#Semi-fixed settings (scope within container)
$UpgradeSettings.UpgradeFolder = 'C:\ProgramData\NavContainerHelper\Upgrades' #locally in the container
$UpgradeSettings.ObjectLibrary = Join-Path $UpgradeSettings.UpgradeFolder '_ObjectLibrary'
$UpgradeSettings.ResultFolder = Join-Path $UpgradeSettings.UpgradeFolder "$($UpgradeSettings.UpgradeName)_Result"
$UpgradeSettings.LanguagesFolder = Join-Path $UpgradeSettings.ResultFolder "Languages"

$UpgradeSettings.OriginalObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.OriginalVersion).txt"
$UpgradeSettings.ModifiedObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.ModifiedVersion).txt"
$UpgradeSettings.TargetObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.TargetVersion).txt"

#ContainerSettings
$ContainerName = 'Upgrade'
$ContainerUserName = 'waldo'
$ContainerPassword = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredentials = New-Object System.Management.Automation.PSCredential ($ContainerUserName, $ContainerPassword)
$ContainerImage = 'mcr.microsoft.com/businesscentral/onprem:be' 
$ContainerLicenseFile = $SecretSettings.containerLicenseFile

$ContainerAdditionalParameters = @("--env isBcSandbox=Y","--cpu-count 8","--dns=8.8.8.8")

#Just to update the modules to my local latest uncommitted version to be able to test them
#import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force 
