. (Join-Path $PSScriptRoot '.\_Settings.ps1')

Enter-PSSession `
    -ComputerName $DockerHost `
    -Credential $DockerHostCredentials `
    -UseSSL:$DockerHostUseSSL `
    -SessionOption $DockerHostSessionOption

Enter-NavContainer -containerName 'devpreview'