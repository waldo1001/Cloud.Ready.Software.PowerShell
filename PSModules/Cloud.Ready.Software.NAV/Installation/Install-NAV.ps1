function Install-NAV
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $DVDFolder,
        [Parameter(Mandatory=$true)]
        $Configfile,
        [Parameter(Mandatory=$false)]
        $LicenseFile,
        [Parameter(Mandatory=$true)]
        $Log
    )
    process
    {
        $Logdir = [io.path]::GetDirectoryName($Log)
        if (!(Test-Path $Logdir)) {New-Item -Path $Logdir -ItemType directory}

        $ConfigFile = Get-Item $Configfile

        Write-Host "Starting install from $($DVDFolder) with Configfile $($ConfigFile.Fullname)" -ForegroundColor Green
        [xml]$InstallConfig = Get-Content $Configfile

        $InstallationResult = New-Object System.Object
        $InstallationResult | Add-Member -MemberType NoteProperty -Name Databasename -Value ($InstallConfig.Configuration.Parameter | where Id -eq SQLDatabaseName).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name TargetPath -Value  ($InstallConfig.Configuration.Parameter | where Id -eq TargetPath).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name TargetPathX64 -Value ($InstallConfig.Configuration.Parameter | where Id -eq TargetPathX64).Value
        $InstallationResult | Add-Member -MemberType NoteProperty -Name ServerInstance -Value ($InstallConfig.Configuration.Parameter | where Id -eq NavServiceInstanceName).Value

        #Install
        
        write-host -foregroundcolor green -object 'Installing ...'
        write-host -foregroundcolor green -object "   Database: $($InstallationResult.Databasename)"
        write-host -foregroundcolor green -object "   ServerInstance: $($InstallationResult.ServerInstance)"
        write-host -foregroundcolor green -object ''
        write-host -foregroundcolor green -object 'please be patient ...'      

        if ($DVDFolder.Length -eq 3){
            $SetupPath = "$($DVDFolder)setup.exe"
        } else {
            $SetupPath = Join-Path $DVDFolder 'setup.exe'
        }
        Start-Process $SetupPath -ArgumentList "/config ""$($Configfile.Fullname)""",'/quiet',"/Log ""$($Log)""" -PassThru | Wait-Process

        if ($LicenseFile){
            $null = Import-Module (join-path $InstallationResult.TargetPathX64 'service\navadmintool.ps1' )

            write-host -ForegroundColor Green -Object "Installing licensefile '$Licensefile'"
            $null = Get-NAVServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile
            write-host -ForegroundColor Green -Object "Restarting $($installationresult.ServerInstance)"
            $null = Get-NAVServerInstance  | Set-NAVServerInstance -Restart
        }

        Write-Host 'Log output:' -ForegroundColor Green
        Get-Content $Log | foreach {
            Write-Host "  $_" -ForegroundColor Gray
        }

    }
    end
    {
        $InstallationResult
    }
}
