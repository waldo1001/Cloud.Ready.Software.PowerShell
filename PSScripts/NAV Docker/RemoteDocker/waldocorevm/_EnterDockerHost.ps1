. (Join-Path $PSScriptRoot '.\_Settings.ps1')

Enter-PSSession `
    -ComputerName $DockerHost `
    -Credential $DockerHostCredentials `
    -UseSSL:$DockerHostUseSSL `
    -SessionOption $DockerHostSessionOption 

break

Enter-NavContainer -containerName 'bccurrent'

New-SmbShare -Path C:\ProgramData\NavContainerHelper -Name NavContainerHelper -FullAccess Administrator

docker network create -d transparent tlan --subnet=172.21.31.0/24 --gateway=172.21.31.1
