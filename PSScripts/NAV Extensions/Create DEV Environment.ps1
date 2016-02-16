# Import settings
. (Join-Path $PSScriptRoot 'Set-NAVExtensionSettings.ps1') -ErrorAction Stop

$CopyFromServerInstance = Get-NAVServerInstance $DefaultServerInstance -ErrorAction Stop

$Backupfile = $CopyFromServerInstance | Backup-NAVDatabase -ErrorAction Stop

$CopyFromServerInstance | Enable-NAVServerInstancePortSharing

New-NAVEnvironment -ServerInstance $OriginalServerInstance -BackupFile $Backupfile -ErrorAction Stop -EnablePortSharing -LicenseFile $License
New-NAVEnvironment -ServerInstance $ModifiedServerInstance -BackupFile $Backupfile -ErrorAction Stop -EnablePortSharing -LicenseFile $License
New-NAVEnvironment -ServerInstance $TargetServerInstance -BackupFile $Backupfile -ErrorAction Stop -EnablePortSharing -LicenseFile $License

#ConvertTo-NAVMultiTenantEnvironment -ServerInstance $TargetServerInstance -MainTenantId $TargetTenant

$Backupfile | Remove-Item -Force

Get-NAVServerInstance4 | where serverinstance -match $AppName | select ServerInstance, DatabaseName, ClientServicesPort, State | ft -AutoSize
