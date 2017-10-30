$Name = 'NAV_10_18197_W1_CU10'
$isofile = "C:\_Installs\$Name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2017_ReplaceDB.xml'
$Licensefile    = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2017_BELGIUM_2016 10 24.flf"
$Objectlibrary  = 'C:\Users\Administrator\Dropbox\Dynamics NAV\ObjectLibrary'
$Exportfile = Join-Path $Objectlibrary "$Name.zip"
$Log = 'c:\Temp\Log.txt'

$InstallationResult =
    Install-NAVFromISO `
        -ISOFilePath $isofile `
        -ConfigFile $ConfigFile `
        -Licensefile $Licensefile `
        -Log $Log `
        -DisableCompileBusinessLogic

break

#Export Objects
if (-not (Test-Path $Exportfile)){
    Import-Module "$env:ProgramFiles\Microsoft Dynamics NAV\100\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | Out-Null
 
    write-host -foregroundcolor Green -Object "Exporting all objects to $Objectlibrary"
    
    $TempFile = "$env:TEMP\$name.txt"
        
    Export-NAVApplicationObject -DatabaseName $InstallationResult.Databasename -Path $TempFile -ExportTxtSkipUnlicensed -ErrorAction Stop

    Get-Item $TempFile | Create-ZipFileFromPipedItems -zipfilename $Exportfile
    Remove-Item $TempFile -Force -ErrorAction SilentlyContinue
    
}

