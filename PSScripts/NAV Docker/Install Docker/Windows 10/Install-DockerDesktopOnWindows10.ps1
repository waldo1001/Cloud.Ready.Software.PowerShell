#Download latest nightly build (Docker Desktop - Windows (Edge))
$DockerInstallFile = "$env:USERPROFILE\Downloads\DockerInstall.exe" 
Invoke-WebRequest -UseBasicparsing -Outfile $DockerInstallFile "https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe"

#Run Install
start $DockerInstallFile

# Allow access to Docker Engine without admin rights
# https://www.axians-infoma.com/techblog/allow-access-to-the-docker-engine-without-admin-rights-on-windows/
[System.IO.Directory]::GetAccessControl("\\.\pipe\docker_engine") | Format-Table -Wrap
Install-Module -Name dockeraccesshelper -Force
Add-AccountToDockerAccess "$env:UserDomain\$env:UserName"

# Test docker
docker run hello-world:nanoserver #you don't need to do this - you can also just trust me :-).

# Install NAVContainerHelper
install-module -Name navcontainerhelper -Force

# Install waldo's "CRS.NavContainerHelperExtension" - Some more functions to make your life a bit easier
Install-Module -Name "CRS.NavContainerHelperExtension" -Force 

