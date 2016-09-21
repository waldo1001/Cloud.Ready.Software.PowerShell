$Licensefile    = 'C:\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$NAVDVD         = 'E:\'
$ConfigFile     = join-path $PSScriptRoot 'FullInstallMadeiraCTP.xml'
$Log            = 'C:\Temp\Log.txt'

$InstallationResult = Install-NAV -DVDFolder $NAVDVD -Configfile $ConfigFile -Log $Log

$null = Import-Module (join-path $InstallationResult.TargetPathX64 'service\navadmintool.ps1' )

write-host -ForegroundColor Green -Object "Installing licensefile '$Licensefile'"
$null = Get-NAVServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile
write-host -ForegroundColor Green -Object "Restarting $($installationresult.ServerInstance)"
$null = Get-NAVServerInstance  | Set-NAVServerInstance -Restart

