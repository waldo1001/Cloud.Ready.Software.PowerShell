function UnInstall-NAVFromISO
{
    <#
        .SYNOPSIS
        Installs NAV from an ISO file
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]
        $ISOFilePath,
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]
        $Log
    )
    Mount-DiskImage -ImagePath $ISOFilePath 
    $iSOImage = Get-DiskImage -ImagePath $ISOFilePath | Get-Volume
    $DVDFolder = "$($IsoImage.DriveLetter):\"
    write-host "Mounted ISO to $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green
    
    UnInstall-NAV -DVDFolder $DVDFolder -Log $Log
    
    Dismount-DiskImage -ImagePath $ISOFilePath
    write-host "Dismounted $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green
    
}

