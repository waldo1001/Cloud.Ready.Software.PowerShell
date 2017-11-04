<#

    .SYNOPSIS  
        Install/Upgrade Docker EE (Windows Server).

    .DESCRIPTION  
        This script checks the official Docker EE (for Windows Server) repository and
        detects the latest version available to download and install. It also compares
        with the version currently installed on the Docker host (WinServer) and asks
        you if you wish to proceed or not.
        You can use the script for the initial installation as well for upgrades that can
        be also canceled once you can see there is a version you don`t want to be installed.

        TO-DO:
            - Download docker-compose.exe file after the installation has been done 
              (this file is being removed with each installation).

    .NOTES  
        File Name  : 01_InstallDockerEE.ps1  
        Author     : Jakub Vanak (https://github.com/Koubek)  
        Requires   : PowerShell V2 CTP3

    .NOTES
        # Silent install:
        .\01_InstallDockerEE.ps1
        
        # Use verbose to see the progress:
        .\01_InstallDockerEE.ps1 -Verbose
    
#>
[CmdletBinding()]
param(
)

Write-Verbose "Starting Docker EE installation/upgrade process."

# Test OS (WinServer only)
Write-Verbose "Running OS compatibility tests."
$osInfo =  Get-WMIObject Win32_OperatingSystem | select-object Caption, ProductType, Version
$osMajorVersion = ([System.Version]$osInfo.Version).Major
# ProductType: Work Station (1), Domain Controller (2), Server (3)
if ($osInfo.ProductType -ne 3) {
    Write-Error "You can run this script only on Windows Server (this is the only Docker EE platform supported by Microsoft)."
    exit 1
}
if ($osMajorVersion -lt 10) {
    Write-Error "You can install and run Docker EE on Windows Server 2016 and higher."
    exit 1
}
Write-Verbose "Your platform should be Docker EE compatible."


# Check end eventually install DockerProvider.
if ((Get-Module DockerProvider -ListAvailable | Measure-Object).Count -eq 0) {
    # Install DockerProvider because is missing.
    Write-Verbose "Installing DockerProvider because it is being missing."
    Install-Module DockerProvider -Force
}

# Installed version check
Write-Verbose "Checking your Docker host to detect previous installations."
$installedVersion = Get-Package -Name Docker -ProviderName DockerProvider

if (($installedVersion | Measure-Object).Count = 1) {

    # Docker version upgrade
    Write-Verbose "You have Docker EE already installed. Starting upgrade process."

    $latestVersion = Find-Package -Name Docker -ProviderName DockerProvider

    if ($latestVersion.Version -eq $installedVersion.Version) {

        Write-Verbose "You have been already running the latest version, nothing to upgrade."

    } else {

        $upgradeQuestion = "Do you want to upgrade from $($installedVersion.Version) to $($latestVersion.Version), Yes or No?"
        $upgradeAnswer = Read-Host $upgradeQuestion

        while("yes","no" -notcontains $upgradeAnswer)
        {
            $upgradeAnswer = Read-Host $upgradeQuestion
        }

        switch ($upgradeAnswer) {
            "yes" {
                Write-Verbose "Upgrading an existing Docker EE version."
                Install-Package -Name docker -ProviderName DockerProvider -Update -Force
                Write-Verbose "The upgrading has finished."
                Write-Verbose "Starting Docker EE service."
                Start-Service Docker
                if ((Get-Service Docker).Status -eq 'Running') {
                    Write-Verbose "Starting Docker EE service should be running."
                    exit 0
                } else {
                    Write-Error "Docker EE Service is not running. Please, test the installation again or check system logs."
                    exit 1
                }
            }
            Default {
                Write-Verbose "Existing without upgrade to the newest version."
            }
        }
    }
} else {
    # Install Docker Version
    Write-Verbose "Starting fresh installation as there is no Docker EE release installed on the system yet."
    Install-Package -Name docker -ProviderName DockerProvider
    Write-Warning "You should reboot the server to finish the installation process."
    exit 0
}

exit 0