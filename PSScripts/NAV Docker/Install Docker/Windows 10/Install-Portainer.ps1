#Install Portainer
docker pull portainer/portainer
if (!(test-path C:\ProgramData\Portainer)){New-Item -Path C:\ProgramData\Portainer -ItemType Directory}
docker run -d --restart always --name portainer --isolation process -h portainer -p 9000:9000 -v C:\ProgramData\Portainer:C:\Data -v //./pipe/docker_engine://./pipe/docker_engine portainer/portainer
