#The app
$AppName = 'WaldoNAVPad'
$AppPublisher = 'Cloud Ready Software GmbH'
$AppDescription = 'WaldoNAVPadApp'
$InitialAppVersion = '1.0.0.0'
$IncludeFilesInNavApp = ''

#The build environment
$WorkingFolder = 'C:\_Workingfolder'

$OriginalServerInstance = "Shared_ORIG"
$ModifiedServerInstance = "$($AppName)_DEV"
$TargetServerInstance = "Shared_TEST"
$TargetTenant = 'Default'
$License = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2016 08 03.flf"
$ISVNumberRangeLowestNumber = 82100

#Defaults
$DefaultServerInstance = 'DynamicsNAV100'
$NavAppWorkingFolder = join-path $WorkingFolder $AppName
$BackupPath = [io.path]::GetFullPath((Join-Path $PSScriptRoot '\..\'))