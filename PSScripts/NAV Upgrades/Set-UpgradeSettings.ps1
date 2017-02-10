<#
This is the settings file for the corresponding scripts in the folder.
so it should be changed to accomodate the merge you're working on

I would just copy scripts and (this) settings file to workingfolder, and go from there...
#>

#General
$UpgradeName = 'Xenics'
$WorkingFolder = "C:\_Workingfolder\Upgrade_$UpgradeName"
$ObjectLibrary = 'C:\_ObjectLibrary'
$ModifiedFolder = 'C:\_Customers'
$NAVLicense = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2017_BELGIUM_2016 10 24.flf"
$UpgradeCodeunitsFullPath = ''
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
$TargetServerInstance = 'DynamicsNAV100'
$TargetObjects = join-path $ObjectLibrary "$($TargetVersion).txt"

#Result Version
$ResultObjectFile = Join-Path $WorkingFolder 'Result.fob'

