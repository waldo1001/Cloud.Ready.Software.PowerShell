# Import settings
. (Join-Path $PSScriptRoot 'Set-NAVExtensionSettings.ps1')

Backup-NAVApplicationObjects `
    -ServerInstance $ModifiedServerInstance `
    -BackupOption OnlyModified `
    -BackupPath $BackupModifiedObjectsPath `
    -NavAppOriginalServerInstance $OriginalServerInstance `
    -NavAppWorkingFolder $NavAppWorkingFolder `
    -ExportPermissionSetId $AppName `
  | copy-item -Destination $BackupCloudFolder -Recurse -Force 

Start $BackupCloudFolder
