$Licensefile    = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2015_BELGIUM_2014 10 02.flf'
$ZippedDVDfile  = 'C:\_Installs\481951_NLB_i386_zip.exe'
$DVDDestination = 'C:\_Installs\DVD\'
$WorkingFolder  = 'C:\_TFS\WorkingFolder'

Get-ChildItem -path (Join-Path $PSScriptRoot '..\PSFunctions\*.ps1') | foreach { . $_.FullName}

$VersionInfo = Get-NAVCumulativeUpdateDownloadVersionInfo -SourcePath $ZippedDVDfile

$InstallationPath = Unzip-NAVCumulativeUpdateDownload -SourcePath $ZippedDVDfile -DestinationPath $DVDDestination

$InstallationResult = Install-NAV -DVDFolder $InstallationPath -Configfile (Join-Path $PSScriptRoot 'InstallConfig.xml') 

break

import-module (Join-Path $InstallationResult.TargetPath "\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1")
import-module (Join-Path $InstallationResult.TargetPathX64 "\Service\NAVAdminTool.ps1")

Import-NAVServerLicense -ServerInstance $InstallationResult.ServerInstance -LicenseFile $Licensefile

Break

Export-NAVApplicationObject `
    -DatabaseServer ([Net.DNS]::GetHostName()) `
    -DatabaseName $Databasename `
    -Path (join-path $WorkingFolder ($VersionInfo.Build + '.txt')) `
    -LogPath (join-path $WorkingFolder 'Export\Log') `
    -ExportTxtSkipUnlicensed `
    -Force    


break

UnInstall-NAV -DVDFolder $InstallationPath
