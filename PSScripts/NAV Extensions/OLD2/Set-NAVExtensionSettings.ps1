#The app
$AppName = 'CRS_Ext'
$AppPublisher = 'Cloud Ready Software GmbH'
$AppDescription = 'Description'
$InitialAppVersion = '1.0.0.0'

#The build environment
$WorkingFolder = 'C:\_Workingfolder'

$OriginalServerInstance = "$($AppName)_Original"
$ModifiedServerInstance = "$($AppName)_DEV"
$TargetServerInstance = "$($AppName)_QA"
$TargetTenant = 'Default'
$License = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'

#Defaults
$DefaultServerInstance = 'DynamicsNAV90'
$NavAppWorkingFolder = join-path $WorkingFolder $AppName
$BackupModifiedObjectsPath = Join-Path $NavAppWorkingFolder 'BackupObjects'
$BackupCloudFolder = 'C:\Users\Administrator\Dropbox\GitHub\Cloud.Ready.Software.Extensions\Rental App\Backup Objects'