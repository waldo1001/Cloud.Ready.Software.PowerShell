
Enter-PSSession waldocorevm -Credential (Get-Credential)

Stop-Service docker
#Add port 2375 to deamon.json in docker config

{
      "bridge":"none",
      "hosts": [
             "tcp://0.0.0.0:2375",
             "npipe://"
      ]
}

Start-Service docker

New-NetFirewallRule -Name "Docker" -DisplayName "Docker" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 2375 -Enabled True -Profile Any

docker pull portainer/portainer

New-Item -ItemType Directory -Path C:\ProgramData\Containers\Portainer

docker run -d --restart always --name portainer -h portainer -v C:\ProgramData\Containers\Portainer:C:\Data --network=tlan --ip 172.21.31.10 portainer/portainer




