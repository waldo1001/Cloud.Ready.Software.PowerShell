<#
This script initiates your environment, depending on the settings in your "Set-UpgradeSettings.ps1".

Basically creating and setting up the different folders on your machine.
#>

. (join-path $PSScriptRoot 'Set-UpgradeSettings.ps1')

#Create Workingfolder
if(-not(Test-Path "$WorkingFolder\..")){
    New-Item -Path "$workingfolder\.." -ItemType directory
} 
$ParentWorkingFolder = Get-Item "$workingfolder\.."
Write-Host -ForegroundColor Magenta 'Workingfolder located at:'
Write-Host -ForegroundColor Magenta $ParentWorkingFolder
Write-Host -ForegroundColor Magenta 'THis location is used to put all the temp files, like deltas, exports, joins, ... .'

#Create Scriptfolder
$Scriptfolder = 'c:\_Scriptfolder'
if(-not(Test-Path $Scriptfolder)){
    New-Item -Path $Scriptfolder -ItemType directory
} 

Write-Host -ForegroundColor Yellow 'Your Scriptfolder is:'
write-host -ForegroundColor Yellow $Scriptfolder
write-host -ForegroundColor Yellow 'It is advisable to always copy following scripts to a separate scriptfolder (sub directory), dedicated for your upgrade'
write-host -ForegroundColor Yellow '  - Set-UpgradeSettings.ps1 - Contains the settings specific for an upgrade'
write-host -ForegroundColor Yellow '  - UpgradeDatabase.ps1     - Contains the actual upgrade script - which can be modified per specific upgrade'
write-host -ForegroundColor Yellow 'This way, you can always go back, re-execute the upgrade if necessary'


#Create Object Library
if(-not(Test-Path $ObjectLibrary)){
    New-Item -Path $ObjectLibrary -ItemType directory
} 
Write-Host -ForegroundColor Blue 'Object Library located at:'
Write-Host -ForegroundColor Blue $ObjectLibrary
Write-Host -ForegroundColor Blue 'Please use this location to put your original objects.  Usually the RTM/CU releases from Microsoft.'

#Create Modified folder
if(-not(Test-Path $ModifiedFolder)){
    New-Item -Path $ModifiedFolder -ItemType directory
} 
Write-Host -ForegroundColor Cyan 'Modified Library located at:'
Write-Host -ForegroundColor Cyan $ModifiedFolder
Write-Host -ForegroundColor Cyan 'Please use this location to put your Modified objects.  Usually your customer-versions of the textfiles.'

#Check License
if (-not(Test-Path $NAVLicense)){
    Write-Error "License could not be located at '$NAVLicense'"
}