$Name = 'NAV_Madeira_BE_CTP09'
$isofile = "C:\_Installs\$Name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallMadeiraCTP.xml'
$Licensefile    = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$Objectlibrary  = 'C:\Users\Adm inistrator\Dropbox\Dynamics NAV\ObjectLibrary'
$Exportfile = Join-Path $Objectlibrary "$Name.txt"
$Log = 'c:\Temp\Log.txt'


$InstallationResult =    Install-NAVFromISO `        -ISOFilePath $isofile `        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log

Import-Module "$($InstallationResult.TargetPath)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

#Export Objects
write-host -foregroundcolor Green -Object "Exporting all objects to $Objectlibrary"
Export-NAVApplicationObject -DatabaseName $InstallationResult.Databasename -Path $Exportfile -ExportTxtSkipUnlicensed

