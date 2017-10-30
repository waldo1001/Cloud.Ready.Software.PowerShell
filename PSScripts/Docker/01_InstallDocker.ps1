#https://github.com/Microsoft/Docker-PowerShell
Register-PSRepository -Name DockerPS-Dev -SourceLocation https://ci.appveyor.com/nuget/docker-powershell-dev
Install-Module -Name Docker -Repository DockerPS-Dev -Scope CurrentUser

#https://docs.docker.com/engine/installation/windows/docker-ee/
Install-Module -Name DockerMsftProvider -Force
Unregister-PackageSource -ProviderName DockerMsftProvider -Name DockerDefault -Erroraction Ignore
Register-PackageSource -ProviderName DockerMsftProvider -Name Docker -Location https://download.docker.com/components/engine/windows-server/index.json
Install-Package -Name docker -ProviderName DockerMsftProvider -Source Docker -Force
#Restart-Computer -Force

