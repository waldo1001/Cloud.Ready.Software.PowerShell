$ZipFIle = "D:\Installs\493023_NLD_i386_zip.exe"

$TmpLocation = 'D:\Temp'
$IsoDirectory = 'D:\Installs\'

$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $ZipFIle `
        -TmpLocation $TmpLocation `
        -IsoDirectory $IsoDirectory

