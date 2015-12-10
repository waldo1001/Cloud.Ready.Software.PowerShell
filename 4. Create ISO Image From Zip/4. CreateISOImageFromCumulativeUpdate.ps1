$ZipFIle = 'G:\Installs\Downloads\488113_NLD_i386_zip.exe'

$TmpLocation = 'G:\Temp'
$IsoDirectory = 'G:\Installs'

$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $ZipFIle `
        -TmpLocation $TmpLocation `
        -IsoDirectory $IsoDirectory

