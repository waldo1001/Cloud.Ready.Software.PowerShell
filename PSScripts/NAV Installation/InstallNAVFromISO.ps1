$name = 'NAV2017_BE_CTPGoLive'
$isofile = "C:\_Installs\$name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2017_ReplaceDB.xml'
$Licensefile    = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2016 08 03.flf"
$Log = 'c:\Temp\Log.txt'
$Objectlibrary  = 'C:\Users\Administrator\Dropbox\Dynamics NAV\ObjectLibrary'
$Exportfile = Join-Path $Objectlibrary "$name.zip"

$InstallationResult =    Install-NAVFromISO `        -ISOFilePath $isofile `        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log


Import-Module "$($InstallationResult.TargetPath)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"
Import-Module "$($InstallationResult.TargetPathX64)\Service\NavAdminTool.ps1"
. "$($InstallationResult.TargetPathX64)\Service\NavAdminTool.ps1"

$CurrentServerInstance = Get-NAVServerInstance -ServerInstance $InstallationResult.ServerInstance

#Disable CompileBusinessApplicationAtStartup
$CurrentServerInstance | Set-NAVServerInstance -Stop
$null =     $CurrentServerInstance |        Set-NAVServerConfiguration `            -KeyName CompileBusinessApplicationAtStartup `            -KeyValue False
$CurrentServerInstance | Set-NAVServerInstance -Start

#Export Objects
if (-not (Test-Path $Exportfile)){
    write-host -foregroundcolor Green -Object "Exporting all objects to $Objectlibrary"
    
    $TempFile = "$env:TEMP\$name.txt"
        
    Export-NAVApplicationObject -DatabaseName $InstallationResult.Databasename -Path $TempFile -ExportTxtSkipUnlicensed

    Get-Item $TempFile | Create-ZipFileFromPipedItems -zipfilename $Exportfile
    Remove-Item $TempFile -Force
    
}
#UnInstall-NAVFromISO -ISOFilePath $isofile
#Drop-SQLDatabaseIfExists -Databasename 'NAV2016'



