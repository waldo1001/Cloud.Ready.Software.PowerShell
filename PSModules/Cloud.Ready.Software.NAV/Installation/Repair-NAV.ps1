function Repair-NAV
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $DVDFolder,
        [Parameter(Mandatory=$true)]
        [String] $Log

    )
    process
    {
        write-host -foregroundcolor green -object 'Repairing NAV Installation ...'
        write-host -foregroundcolor green -object ''
        write-host -foregroundcolor green -object 'please be patient ...'      
        
        if ($DVDFolder.Length -eq 3){
            $SetupPath = "$($DVDFolder)setup.exe"
        } else {
            $SetupPath = Join-Path $DVDFolder 'setup.exe'
        }
        Start-Process $SetupPath -ArgumentList '/repair','/quiet',"/Log ""$($Log)""" -PassThru | Wait-Process
    
        Write-Host 'Log output:' -ForegroundColor Green
        Get-Content $Log | foreach {
            Write-Host "  $_" -ForegroundColor Gray
        }
    }

}
