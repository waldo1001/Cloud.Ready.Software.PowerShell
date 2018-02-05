#Example of settings for Azure VM
$DockerHost = 'waldops.westeurope.cloudapp.azure.com'
$DockerHostUseSSL = $true
$DockerHostSessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$UserName = 'vmadmin'
$Password = ConvertTo-SecureString (Get-content (Join-Path $PSScriptRoot '.\password.txt')) -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerLicenseFile = 'https://www.dropbox.com/s/8r85nc2oq5r1mal/CRS%20NAV2018%20DEV%20%20License.flf?dl=1'
$ContainerAdditionalParameters = @()
