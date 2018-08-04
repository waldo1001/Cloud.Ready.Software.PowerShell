. (Join-Path $PSScriptRoot '.\_Settings.ps1')

Enter-PSSession `
    -ComputerName $DockerHost `
    -Credential $DockerHostCredentials `
    -UseSSL:$DockerHostUseSSL `
    -SessionOption $DockerHostSessionOption 

break

Enter-NavContainer -containerName 'devpreview'

winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname = "waldocorevm"; CertificateThumbprint = "DE18102C8F12DB2956B932380775C1CED4DB7051"}