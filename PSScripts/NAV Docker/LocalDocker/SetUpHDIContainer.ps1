<#
Enter-PSSession -Authentication Basic -Credential Administrator -ComputerName WaldoCoreVM 
enter-pssession waldocorevm
#>

$UserName = 'waldo'
$Password = 'waldo1234'
$ContainerName = 'HDI'
$Image = 'navdocker.azurecr.io/dynamics-nav:11.0.19756.0-finus' 
$IP = '172.21.31.7'

$credential = New-Object System.Management.Automation.PSCredential ($UserName, (ConvertTo-SecureString $Password -AsPlainText -Force))

<#
docker login "navdocker.azurecr.io" -u "7cc3c660-fc3d-41c6-b7dd-dd260148fff7" --password "G/7gwmfohn5bacdf4ooPUjpDOwHIxXspLIFrUsGN+sU="
docker pull navdocker.azurecr.io/dynamics-nav:11.0.19756.0-finus
#>

New-NavContainer `
    -accept_eula `
    -containerName $ContainerName `
    -imageName $Image `
    -licenseFile 'https://www.dropbox.com/s/8r85nc2oq5r1mal/CRS%20NAV2018%20DEV%20%20License.flf?dl=1' `
    -alwaysPull `
    -doNotExportObjectsToText `
    -additionalParameters @("--network=tlan","--ip $IP") `
    -auth NavUserPassword `
    -Credential $credential