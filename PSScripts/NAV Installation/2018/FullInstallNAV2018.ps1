$Name = 'NAV_11_CTP1'
$isofile = "C:\_Installs\$Name.iso"
$ConfigFile     = join-path $PSScriptRoot 'FullInstallNAV2018.xml'
$Licensefile    = "C:\Users\Administrator\Dropbox\Dynamics NAV\Licenses\2017 DEV License.flf"
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
    Import-NAVModules

    write-host -foregroundcolor Green -Object "Exporting all objects to $Objectlibrary"
    
    $TempFile = "$env:TEMP\$name.txt"
        
    Export-NAVApplicationObject -DatabaseName $InstallationResult.Databasename -Path $TempFile -ExportTxtSkipUnlicensed -ErrorAction Stop

    Get-Item $TempFile | Create-ZipFileFromPipedItems -zipfilename $Exportfile
    Remove-Item $TempFile -Force -ErrorAction SilentlyContinue
    
}

