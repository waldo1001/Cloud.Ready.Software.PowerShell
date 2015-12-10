
#Install the CU
Get-NAVVersion

Get-NAVCumulativeUpdateDownloadVersionInfo -SourcePath $CUDownloadFile

$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $CUDownloadFile `
        -IsoDirectory $IsoDirectory

Repair-NAVFromISO -ISOFilePath $IsoFile -Log 'c:\TEMP\Log.txt'

Get-NAVVersion

UnInstall-NAVFromISO -ISOFilePath $IsoFile -Log 'c:\TEMP\Log.txt'
Drop-SQLDatabaseIfExists -Databasename 'NAV2016'