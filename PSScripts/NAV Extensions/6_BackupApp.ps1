# Import settings
. (Join-Path $PSScriptRoot '_Settings.ps1') -ErrorAction Stop

$CreatedITems = Backup-NAVApplicationObjects `                    -BackupOption OnlyModified `                    -ServerInstance $ModifiedServerInstance `                    -BackupPath $BackupPath `                    -Name $AppName `                    -NavAppOriginalServerInstance $OriginalServerInstance `                    -NavAppWorkingFolder $NavAppWorkingFolder `
                    -CompleteReset


start $BackupPath