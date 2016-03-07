$Name = 'ApplyTestDeltas'
$DeltaFiles = 'C:\Users\Administrator\Dropbox\GitHub\Waldo.NAV\WaldoNAVPad\AppFiles\*.DELTA'
$TargetServerInstance = 'DynamicsNAV90'
$WorkingFolder = join-path 'c:\_WorkingFolder' $Name


$TargetServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $TargetServerInstance

$SandboxServerInstance = "$($TargetServerInstance)_Sandbox"
$SandboxServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $SandboxServerInstance
if ($SandboxServerInstanceObject) {$SandboxServerInstanceObject | Remove-NAVEnvironment -Force -ErrorAction Stop}
$TargetServerInstanceObject | Copy-NAVEnvironment -ToServerInstance $SandboxServerInstance -ErrorAction Stop

$TargetServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $SandboxServerInstance

Apply-NAVDelta `    -DeltaPath $DeltaFiles `    -TargetServerInstance $TargetServerInstanceObject.ServerInstance `    -Workingfolder $WorkingFolder `    -OpenWorkingfolder `    -SynchronizeSchemaChanges Force `    -DeltaType Add
    

Start-NAVIdeClient -Database $TargetServerInstanceObject.DatabaseName 
Start-NAVWindowsClient -ServerInstance $TargetServerInstanceObject.ServerInstance
