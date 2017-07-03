if (!(test-path c:\backup\Backup.bak)){
    Find-Module | where author -eq waldo | install-module -force
    Import-Module -Name Cloud.Ready.Software.NAV
    Import-NAVModules

    $backup = Backup-NAVDatabase -ServerInstance NAV
    New-Item -Path c:\BACKUP -ItemType Directory -ErrorAction SilentlyContinue
    $backup | Move-Item -Destination c:\backup\Backup.bak
}
start C:\BACKUP