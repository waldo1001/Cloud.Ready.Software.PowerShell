<#
Unregister-PackageSource -ProviderName DockerMsftProvider -Name DockerDefault -Erroraction Ignore
Register-PackageSource -ProviderName DockerMsftProvider -Name Docker -Erroraction Ignore -Location https://download.docker.com/components/engine/windows-server/index.json
Install-Package -Name docker -ProviderName DockerMsftProvider -Update -Force
#>

#https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-server
Get-Package -Name Docker -ProviderName DockerMsftProvider
Find-Package -Name Docker -ProviderName DockerMsftProvider
Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force

# Start the Docker service.
Start-Service Docker