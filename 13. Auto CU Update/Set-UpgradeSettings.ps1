#General
$UpgradeName = 'TestCustomer'
$WorkingFolder = "C:\_Workingfolder\Upgrade_$UpgradeName"
$ObjectLibrary = 'C:\_ObjectLibrary'
$ModifiedFolder = 'C:\_Workingfolder\CustomerDBs'
$NAVLicense = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$UpgradeCodeunitsFullPath = 'E:\UpgradeToolKit\Local Objects\Upgrade800900.BE.fob'
$VersionListPrefixes = 'NAVW1', 'NAVBE'


#Original Version
$OriginalVersion = 'NAV2015_CUx_BE'
$OriginalObjects = join-path $ObjectLibrary "$($OriginalVersion).txt"

#Modified Version
$ModifiedServerInstance = $UpgradeName
$ModifiedObjects = join-path $ModifiedFolder "$($ModifiedServerInstance).txt"
$ModifiedDatabaseBackupLocation = join-path $ModifiedFolder "$($ModifiedServerInstance).bak"

#Target Version
$TargetVersion = 'NAV2016_CU1' 
$TargetServerInstance = 'DynamicsNAV90'
$TargetObjects = join-path $ObjectLibrary "$($TargetVersion).txt"

#Result Version
$ResultObjectFile = Join-Path $WorkingFolder "$($ResultServerInstance).fob"

