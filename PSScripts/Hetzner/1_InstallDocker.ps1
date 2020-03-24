Install-WindowsFeature -Name Containers
Uninstall-WindowsFeature Windows-Defender
Restart-Computer -Force  

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force
Install-Module DockerProvider -Confirm:$false -Force
Install-Package Docker -ProviderName DockerProvider -Confirm:$false -Force
Start-Service docker  

docker image pull mcr.microsoft.com/businesscentral/sandbox

#change agent user to "system"