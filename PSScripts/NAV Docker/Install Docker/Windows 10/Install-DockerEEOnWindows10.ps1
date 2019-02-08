# If this line returns true then reboot and run script again
(Enable-WindowsOptionalFeature -FeatureName containers -Online).RestartNeeded

# On an online machine, download the zip file.
# Check latest url's here: https://download.docker.com/components/engine/windows-server/index.json
$zipfile = "$env:USERPROFILE\Downloads\docker-18.09.1.zip" 
Invoke-WebRequest -UseBasicparsing -Outfile $zipfile https://download.docker.com/components/engine/windows-server/18.09/docker-18.09.1.zip

# Extract the archive.
Expand-Archive $zipfile -DestinationPath $Env:ProgramFiles -Force

# Add Docker to the path for the current session.
$env:path += ";$env:ProgramFiles\docker"

# Optionally, modify PATH to persist across sessions.
$newPath = [Environment]::GetEnvironmentVariable("PATH",[EnvironmentVariableTarget]::Machine) + ";$env:ProgramFiles\docker"
[Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)

# Register the Docker daemon as a service.
dockerd --exec-opt isolation=process --register-service

# Start the Docker service.
Start-Service docker

# Allow access to Docker Engine without admin rights
# https://www.axians-infoma.com/techblog/allow-access-to-the-docker-engine-without-admin-rights-on-windows/
[System.IO.Directory]::GetAccessControl("\\.\pipe\docker_engine") | Format-Table -Wrap
Install-Module -Name dockeraccesshelper
Add-AccountToDockerAccess "$env:UserDomain\$env:UserName"

# Test docker
docker run hello-world:nanoserver
