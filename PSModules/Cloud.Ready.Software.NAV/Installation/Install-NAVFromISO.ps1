function Install-NAVFromISO
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
        
        [Parameter(Mandatory=$true, Position=1)]
        [Object]
        $ConfigFile,
        
        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $Licensefile,

        [Parameter(Mandatory=$true, Position=2)]
        [System.String]
        $Log

    )
    
    $null = Mount-DiskImage -ImagePath $ISOFilePath 
    $iSOImage = Get-DiskImage -ImagePath $ISOFilePath | Get-Volume
    $DVDFolder = "$($IsoImage.DriveLetter):\"
    write-host "Mounted ISO to $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green
    
    $InstallationResult = Install-NAV -DVDFolder $DVDFolder -Configfile $ConfigFile -LicenseFile $Licensefile -Log $Log
    
    $null = Dismount-DiskImage -ImagePath $ISOFilePath
    write-host "Dismounted $($IsoImage.DriveLetter)-Drive" -ForegroundColor Green
    
    #fix installation by registering 
    write-host "Fixing 'Run' from DEV enviromnent" -ForegroundColor Green
    $RegasmFile = (Get-childItem -Path "$env:windir\Microsoft.NET\Framework\" -Filter 'RegAsm.exe' -recurse -ErrorAction SilentlyContinue | sort Fullname | select -Last 1).Fullname
    $RegasmArguments = "/register ""$($InstallationResult.TargetPath)\RoleTailored Client\Microsoft.Dynamics.Nav.Client.WinForms.dll"" /tlb"
    Start -FilePath $RegasmFile -ArgumentList $RegasmArguments

    return $InstallationResult
}

