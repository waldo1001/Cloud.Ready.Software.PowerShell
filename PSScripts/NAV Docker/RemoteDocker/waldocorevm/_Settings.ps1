#Example of settings for local docker machine
$DockerHost = 'waldocorevm'
$DockerHostUseSSL = $false
$DockerHostSessionOption = New-PSSessionOption

$UserName = 'administrator'
$Password = ConvertTo-SecureString (Get-content (Join-Path $PSScriptRoot '.\password.txt')) -AsPlainText -Force
$DockerHostCredentials = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerLicenseFile = 'https://www.dropbox.com/s/8r85nc2oq5r1mal/CRS%20NAV2018%20DEV%20%20License.flf?dl=1'
$ContainerAdditionalParameters = @("--network=tlan","--ip 172.21.31.4")
