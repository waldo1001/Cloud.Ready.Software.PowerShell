$ZipFIle = "D:\Installs\493041_intl_i386_zip.exe"

$TmpLocation = 'D:\Temp'
$IsoDirectory = 'D:\Installs\'

$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $ZipFIle `
        -TmpLocation $TmpLocation `
        -IsoDirectory $IsoDirectory

