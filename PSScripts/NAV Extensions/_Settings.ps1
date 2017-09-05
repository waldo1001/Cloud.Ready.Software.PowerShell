#The app
$AppName = 'HelloWorld'
$AppPublisher = 'Cloud Ready Software GmbH'
$AppDescription = 'HelloWorld'
$InitialAppVersion = '1.0.0.0'
$IncludeFilesInNavApp = ''
$WebServicePrefix = 'HWW'
$Logo = get-item '..\Images\Icon.png'

#The build environment
$WorkingFolder = 'C:\_Workingfolder'

$OriginalServerInstance = "Shared_ORIG"
$ModifiedServerInstance = "$($AppName)_DEV"
$TargetServerInstance = "Shared_TEST"
$TargetTenant = 'Default'
$License = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\2017 DEV License.flf"
$ISVNumberRangeLowestNumber = 50000

#Defaults
$DefaultServerInstance = 'DynamicsNAV100'
$NavAppWorkingFolder = join-path $WorkingFolder $AppName
$BackupPath = [io.path]::GetFullPath((Join-Path $PSScriptRoot '\..\'))

#Run Test
$TestWindowsClient = $false
$TestWebClient = $true
$TestTabletClient = $false
$TestPhoneClient = $false