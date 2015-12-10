function Repair-NAVFromISO
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]
        $ISOFilePath,
        
        [Parameter(Mandatory=$true, Position=2)]
        [System.String]
        $Log

    )
    process
    {
        
        $null = Mount-DiskImage -ImagePath $ISOFilePath 
        $iSOImage = Get-DiskImage -ImagePath $ISOFilePath | Get-Volume
        $DVDFolder = "$($IsoImage.DriveLetter):\"
        write-host "Mounted ISO to $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green
    
        Repair-NAV -DVDFolder $DVDFolder -Log $Log

        $null = Dismount-DiskImage -ImagePath $ISOFilePath
        write-host "Dismounted $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green


        
    }

}
