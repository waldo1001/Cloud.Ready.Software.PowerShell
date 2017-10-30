$ZipFIle = "C:\_Downloads\Dynamics.100.DE.2087085.DVD.zip"
$TmpLocation = 'C:\TmpIsoCreation\2017'
$ISOName = 'NAV_10_DE_RTM'
$IsoFileName = '\\waldonas2\public\Software\$Microsoft\Dynamics NAV\NAV 2017' + "\$ISOName.iso"


IF (Test-Path $TmpLocation){
    if (Confirm-YesOrNo -title "Remove $TmpLocation" -message "Do you want to remove $TmpLocation ?") {
        Remove-Item -Path $TmpLocation -Recurse
    } else { 
        Write-Error "'$TmpLocation' should not exist.  Please remove first"
        break
    }
}
New-Item -ItemType directory -Path $TmpLocation 

write-host "Unzipping to '$TmpLocation'" 
Unzip-Item -SourcePath $ZipFIle -DestinationPath $TmpLocation

Write-host "Creating ISO file '$ISOFileName'"
New-ISOFileFromFolder -FilePath $TmpLocation -Name $ISOName -ResultFullFileName $IsoFileName
