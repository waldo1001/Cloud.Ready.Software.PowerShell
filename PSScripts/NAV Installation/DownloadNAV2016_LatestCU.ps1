$NAVVersion = 2016
$TmpLocation = 'c:\Temp'
$ISODir = 'C:\_Installs'

$Download = Get-NAVCumulativeUpdateFile -CountryCodes BE -versions $NAVVersion -DownloadFolder $ISODir

$NAVISOFile = New-NAVCumulativeUpdateISOFile -CumulativeUpdateFullPath $Download.filename -TmpLocation $TmpLocation -IsoDirectory $ISODir 