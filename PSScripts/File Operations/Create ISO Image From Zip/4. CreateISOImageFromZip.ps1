$ZipFIle = 'C:\_Installs\Dynamics.Main.BE.1835491.DVD.zip'
$TmpLocation = 'C:\Temp'
$ISOName = 'NAV_Madeira_BE_CTP09'
$IsoFileName = 'C:\_Installs' + "\$ISOName.iso"


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
