function Install-DockerOnWinServer {
    <#
        TO-DO
            - Download compose file after the installation has been done (this is removed with each installation).
    #>
    [CmdletBinding()]
    param(
    )

    if ((Get-Module DockerMsftProvider -ListAvailable | Measure-Object).Count -eq 0) {
        # Install DockerMsftProvider because is missing.
        Write-Verbose "Installing DockerMsftProvider because it is being missing."
        Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
    }

    # Installed version check
    $installedVersion = Get-Package -Name Docker -ProviderName DockerMsftProvider

    if (($installedVersion | Measure-Object).Count = 1) {

        # Docker version upgrade
        $latestVersion = Find-Package -Name Docker -ProviderName DockerMsftProvider

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
                    Install-Package -Name docker -ProviderName DockerMsftProvider -Update -Force
                    Start-Service Docker
                }
                Default {
                    Write-Verbose "Existing without upgrade to the newest version."
                }
            }

        }

    } else {

        # Install Docker Version
        Install-Package -Name docker -ProviderName DockerMsftProvider
        Write-Warning "You should reboot the server to finish the installation process."
    }
}