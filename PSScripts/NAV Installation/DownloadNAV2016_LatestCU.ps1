$Download = Get-NAVCumulativeUpdateFile -CountryCodes BE -versicumulaons 2016 -DownloadFolder 'C:\_Installs' 

New-NAVCumulativeUpdateISOFile -CumulativeUpdateFullPath $Download.filename -TmpLocation c:\Temp -IsoDirectory C:\_Installs 

