Copy-Item -Path "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\traefik.yml" -Destination "C:\ProgramData\BcContainerHelper\traefikforbc\config\traefik.yml" -Force 

docker pull traefik:windowsservercore-1809




docker run --name traefik -p 8080:8080 -p 443:443 -p 80:80 -p 7047:7047 -p 7048:7048 -p 7049:7049 -p 9000:9000 --restart always -d -v "c:\programdata\bccontainerhelper\traefikforbc\config:c:/etc/traefik" -v \\.\pipe\docker_engine:\\.\pipe\docker_engine traefik:windowsservercore-1809 --providers.docker.endpoint=npipe:////./pipe/docker_engine

Docker stop traefik
docker rm traefik
docker run --name traefik -p 8080:8080 -p 443:443 -p 80:80 -p 7047:7047 -p 7048:7048 -p 7049:7049 -p 9000:9000 --restart always -d -v "C:\ProgramData\BcContainerHelper\traefikforbc\config:c:/etc/traefik" -v \\.\pipe\docker_engine:\\.\pipe\docker_engine traefik:windowsservercore-1809 --providers.docker.endpoint=npipe:////./pipe/docker_engine
docker logs traefik
