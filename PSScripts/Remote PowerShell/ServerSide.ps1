#Source: https://4sysops.com/archives/powershell-remoting-over-https-with-a-self-signed-ssl-certificate/

$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName ([net.dns]::GetHostName())

Export-Certificate -Cert $Cert -FilePath C:\temp\cert

Enable-PSRemoting -SkipNetworkProfileCheck -Force

dir wsman:\localhost\listener

Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse
Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force

New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true
Set-NetConnectionProfile -NetworkCategory Private

Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

Write-Host "Copy the certificate (c:\temp\cert) to the local machine"