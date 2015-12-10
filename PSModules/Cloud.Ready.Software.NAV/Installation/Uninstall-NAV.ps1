function UnInstall-NAV
{
    [CmdletBinding()]
    Param
    (
        [String] $DVDFolder,
        [String] $Log
    )
    process
    {
        #Install
        write-host 'Uninstalling NAV...' -ForegroundColor Green
        
        if ($DVDFolder.Length -eq 3){
            $SetupPath = "$($DVDFolder)setup.exe"
        } else {
            $SetupPath = Join-Path $DVDFolder 'setup.exe'
        }
        Start-Process $SetupPath -ArgumentList '/uninstall', '/quiet',"/Log ""$($Log)""" -PassThru| Wait-Process

        Write-Host 'Log output:' -ForegroundColor Green
        Get-Content $Log | foreach {
            Write-Host "  $_" -ForegroundColor Gray
        }
    }
}
