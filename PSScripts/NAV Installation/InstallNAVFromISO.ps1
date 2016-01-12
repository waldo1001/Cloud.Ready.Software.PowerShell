$isofile = 'C:\_Installs\NAV_9_44365_BE.iso'
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2016.xml'
$Licensefile    = 'C:\_Installs\5230132_003 and 004 IFACTO_NAV2016_BELGIUM_2015 11 03.flf'
$Log = 'c:\Temp\Log.txt'

$InstallationResult =    Install-NAVFromISO `        -ISOFilePath $isofile `        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log

#UnInstall-NAVFromISO -ISOFilePath $isofile
#Drop-SQLDatabaseIfExists -Databasename 'NAV2016'
