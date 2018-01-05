<#
Enter-PSSession -Authentication Basic -Credential Administrator -ComputerName WaldoCoreVM 
enter-pssession waldocorevm
#>

$UserName = 'waldo'
$Password = 'waldo1234'
$ContainerName = 'devpreview'
$Image = 'microsoft/dynamics-nav:devpreview' 
$IP = '172.21.31.4'

$credential = New-Object System.Management.Automation.PSCredential ($UserName, (ConvertTo-SecureString $Password -AsPlainText -Force))

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
    