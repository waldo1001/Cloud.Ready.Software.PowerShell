$name = 'NAV_9_45243_BE'
$isofile = "C:\_Installs\$name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2016.xml'
$Licensefile    = 'C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$Log = 'c:\Temp\Log.txt'
$Objectlibrary  = 'C:\Users\Administrator\Dropbox\Dynamics NAV\ObjectLibrary'
$Exportfile = Join-Path $Objectlibrary "$name.zip"

$InstallationResult =    Install-NAVFromISO `        -ISOFilePath $isofile `        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log


Import-Module "$($InstallationResult.TargetPath)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"
Import-Module "$($InstallationResult.TargetPathX64)\Service\Microsoft.Dynamics.Nav.Management.dll"

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
    Remove-Item $TempFile -Force -ErrorAction SilentlyContinue
    
}



#UnInstall-NAVFromISO -ISOFilePath $isofile
#Drop-SQLDatabaseIfExists -Databasename 'NAV2016'



