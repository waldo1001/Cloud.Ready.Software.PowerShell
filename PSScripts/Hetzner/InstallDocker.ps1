# Install-WindowsFeature Hyper-V, Containers -Restart
# Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force
# Install-Module DockerProvider -Confirm:$false -Force
# Install-Package Docker -ProviderName DockerProvider -Confirm:$false -Force

Invoke-WebRequest -Uri get.mirantis.com/install.ps1 -OutFile c:\temp\Install-Mirantis.ps1

psedit c:\temp\Install-Mirantis.ps1