$Name = 'ApplyTestDeltas'
$DeltaFiles = 'C:\_WorkingFolder\ApplyTestDeltas\ReverseDeltas\*.DELTA'
$TargetServerInstance = 'DynamicsNAV90_Sandbox'
$WorkingFolder = join-path 'c:\_WorkingFolder' "$($Name)_Reverse"

$TargetServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $TargetServerInstance

$SandboxServerInstance = "$($TargetServerInstance)_Sandbox"
$SandboxServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $SandboxServerInstance
if ($SandboxServerInstanceObject) {$SandboxServerInstanceObject | Remove-NAVEnvironment -Force -ErrorAction Stop}
$TargetServerInstanceObject | Copy-NAVEnvironment -ToServerInstance $SandboxServerInstance -ErrorAction Stop

$TargetServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $SandboxServerInstance


Apply-NAVDelta `    -DeltaPath $DeltaFiles `    -TargetServerInstance $TargetServerInstanceObject.ServerInstance `    -Workingfolder $WorkingFolder `    -OpenWorkingfolder `    -DoNotImportAndCompileResult:$false `    -SynchronizeSchemaChanges Force `    -ModifiedProperty FromModified `    -VersionListAction Remove

Start-NAVIdeClient -Database $TargetServerInstanceObject.DatabaseName 
Start-NAVWindowsClient -ServerInstance $TargetServerInstanceObject.ServerInstance
