
# Import settings
. (Join-Path $PSScriptRoot 'Set-NAVExtensionSettings.ps1')

#Rebuild Test Environment
$CopyFromServerInstance = Get-NAVServerInstance $OriginalServerInstance

Remove-NAVEnvironment -ServerInstance $TargetServerInstance 

$CopyFromServerInstance | Copy-NAVEnvironment -ToServerInstance $TargetServerInstance
ConvertTo-NAVMultiTenantEnvironment -ServerInstance $TargetServerInstance -MainTenantId $TargetTenant

