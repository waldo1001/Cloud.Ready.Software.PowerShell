$Name = 'NAV_Madeira_BE_CTP16'
$isofile = "C:\_Installs\$Name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallMadeiraCTP.xml'
$Licensefile    = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$Objectlibrary  = 'C:\Users\Administrator\Dropbox\Dynamics NAV\ObjectLibrary'
$Exportfile = Join-Path $Objectlibrary "$Name.zip"
$Log = 'c:\Temp\Log.txt'

$InstallationResult =    Install-NAVFromISO `        -ISOFilePath $isofile `        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log

#Export Objects
if (-not (Test-Path $Exportfile)){
    Import-Module "$($InstallationResult.TargetPath)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

    write-host -foregroundcolor Green -Object "Exporting all objects to $Objectlibrary"
    
    $TempFile = "$env:TEMP\$name.txt"
        
    Export-NAVApplicationObject -DatabaseName $InstallationResult.Databasename -Path $TempFile -ExportTxtSkipUnlicensed

    Get-Item $TempFile | Create-ZipFileFromPipedItems -zipfilename $Exportfile
    Remove-Item $TempFile -Force -ErrorAction SilentlyContinue
    
}
