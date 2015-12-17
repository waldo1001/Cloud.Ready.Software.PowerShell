<#
This is the settings file for the corresponding scripts in the folder.
so it should be changed to accomodate the merge you're working on

I would just copy scripts and (this) settings file to workingfolder, and go from there...
#>

#General
$UpgradeName = 'FLEETNOLOGY'
$WorkingFolder = "G:\Merge\_Workingfolder\Upgrade_$UpgradeName"
$ObjectLibrary = 'G:\Merge\_ObjectLibrary'
$ModifiedFolder = 'G:\Merge\_Workingfolder\CustomerDBs'
$NAVLicense = 'G:\Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$UpgradeCodeunitsFullPath = 'E:\UpgradeToolKit\Local Objects\Upgrade800900.BE.fob'
$VersionListPrefixes = 'NAVW1', 'NAVBE', 'I'


#Original Version
$OriginalVersion = 'DISTRI82'
$OriginalObjects = join-path $ObjectLibrary "$($OriginalVersion).txt"

#Modified Version
$ModifiedServerInstance = $UpgradeName
$ModifiedObjects = join-path $ModifiedFolder "$($ModifiedServerInstance).txt"
$ModifiedDatabaseBackupLocation = join-path $ModifiedFolder "$($ModifiedServerInstance).bak"

#Target Version
$TargetVersion = 'DISTRI91' 
$TargetServerInstance = 'DynamicsNAV90'
$TargetObjects = join-path $ObjectLibrary "$($TargetVersion).txt"

#Result Version
$ResultObjectFile = Join-Path $WorkingFolder 'Result.fob'

