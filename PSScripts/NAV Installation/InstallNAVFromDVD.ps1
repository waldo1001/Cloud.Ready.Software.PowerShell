$Licensefile    = 'C:\_Installs\Corfu - iFacto Business Solutions NV.FLF'
$NAVDVD         = 'D:\'
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2016.xml'

$InstallationResult = Install-NAV -DVDFolder $NAVDVD -Configfile $ConfigFile

$null = Import-Module (join-path $InstallationResult.TargetPathX64 'service\navadmintool.ps1' )

write-host -ForegroundColor Green -Object "Installing licensefile '$Licensefile'"
$null = Get-NAVServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile
write-host -ForegroundColor Green -Object "Restarting $($installationresult.ServerInstance)"
$null = Get-NAVServerInstance  | Set-NAVServerInstance -Restart

