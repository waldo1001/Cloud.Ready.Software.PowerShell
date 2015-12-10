Import-Certificate -Filepath "C:\temp\cert" -CertStoreLocation "Cert:\LocalMachine\Root"

Enter-PSSession -ComputerName WIN-K5JLU49T31O -UseSSL -Credential (Get-Credential)