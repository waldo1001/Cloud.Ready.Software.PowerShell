
#install Chocolatey
#https://chocolatey.org/install
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#install docker
#https://chocolatey.org/packages/docker-desktop
choco install docker-desktop

