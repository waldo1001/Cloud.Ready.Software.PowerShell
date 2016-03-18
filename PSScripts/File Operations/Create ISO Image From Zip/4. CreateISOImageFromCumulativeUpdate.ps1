$ZipFIle = 'C:\_Download\490357_NLD_i386_zip.exe'

$TmpLocation = 'D:\Temp'
$IsoDirectory = 'D:\Installs\'

$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $ZipFIle `
        -TmpLocation $TmpLocation `
        -IsoDirectory $IsoDirectory

