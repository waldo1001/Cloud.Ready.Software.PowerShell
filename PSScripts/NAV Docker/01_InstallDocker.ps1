<#
#https://github.com/Microsoft/Docker-PowerShell
Register-PSRepository -Name DockerPS-Dev -SourceLocation https://ci.appveyor.com/nuget/docker-powershell-dev
Install-Module -Name Docker -Repository DockerPS-Dev -Scope CurrentUser

#https://docs.docker.com/engine/installation/windows/docker-ee/
Install-Module -Name DockerMsftProvider -Force
Unregister-PackageSource -ProviderName DockerMsftProvider -Name DockerDefault -Erroraction Ignore
Unregister-PackageSource -ProviderName DockerMsftProvider -Name Docker -Erroraction Ignore
Register-PackageSource -ProviderName DockerMsftProvider -Name Docker -Location https://download.docker.com/components/engine/windows-server/index.json
Install-Package -Name docker -ProviderName DockerMsftProvider -Source Docker -Force
#Restart-Computer -Force
#>

#https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-server
#  install the Docker-Microsoft PackageManagement Provider 
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
#  use the PackageManagement PowerShell module to install the latest version of Docker
Install-Package -Name docker -ProviderName DockerMsftProvider

#navcontainerhelper
find-module 'navcontainerhelper' | install-module

Restart-Computer -Force