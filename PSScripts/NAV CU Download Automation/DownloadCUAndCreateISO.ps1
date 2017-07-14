$CULibrary = '\\waldonas2\public\Software\$Microsoft\Dynamics NAV'
$LocalDownloadFolder = 'C:\_Downloads'
$LocalTmpLocation = 'C:\TmpIsoCreation'
$CountryVersions = 'BE', 'W1'
$NAVVersion = '2017'

foreach ($CountryVersion in $CountryVersions){
    $LocalDownloadFile = Get-NAVCumulativeUpdateFile -version $NAVVersion -CountryCode $CountryVersion -DownloadFolder $LocalDownloadFolder -GetInfoOnly
    $LocalDownloadFileJSON = join-path $LocalDownloadFolder "$([io.path]::GetFileNameWithoutExtension($LocalDownloadFile.filename)).json"
    $CULibraryNAVVersion = join-path $CULibrary "NAV $($LocalDownloadFile.NAVVersion)"
    $CULibraryNAVVersionJSON = join-path $CULibraryNAVVersion "$([io.path]::GetFileNameWithoutExtension($LocalDownloadFile.filename)).json"
    $LocalTmpLocationCountry = Join-Path $LocalTmpLocation $CountryVersion
    
    if (Test-Path $CULibraryNAVVersionJSON){
        Write-Warning "Already downloaded CU$($LocalDownloadFile.CUNo) for NAV $($LocalDownloadFile.NAVVersion).  Location: $CULibraryNAVVersion"
    } else {
        $LocalDownloadFile = Get-NAVCumulativeUpdateFile -version $NAVVersion -CountryCode $CountryVersion -DownloadFolder $LocalDownloadFolder -Verbose 
    
        $LocalIsoFile = New-NAVCumulativeUpdateISOFile -CumulativeUpdateFullPath $LocalDownloadFile.filename -TmpLocation $LocalTmpLocationCountry -IsoDirectory $LocalDownloadFolder -FileNameSuffix "CU$($LocalDownloadFile.CUNo)" -ErrorAction Stop -Force
        
        #Move to Final Destination
        Move-Item -Path $LocalDownloadFileJSON -Destination $CULibraryNAVVersion -Force
        Move-Item -Path $LocalIsoFile.FullName -Destination $CULibraryNAVVersion -Force
    }
   
    #Remove Previous
    #Remove-Item -Path $LocalDownloadFile.filename
    #Write-Warning 'TODO: Remove Previous?'
}

if ($CULibraryNAVVersion){
    start $CULibraryNAVVersion
}