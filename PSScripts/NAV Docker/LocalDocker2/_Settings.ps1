#Example of settings for when your dockerhost is installed on a local VM
$SecretSettings = Get-ObjectFromJSON (Join-Path $PSScriptRoot "_SecretSettings.json") #Secret Settings, stored in a .json file, and ignored by git

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$UserName = 'sa'
$ContainerSqlCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

#$ContainerAdditionalParameters = @("--env isBcSandbox=Y","--cpu-count 8","--dns=8.8.8.8")
$ContainerAdditionalParameters = @("--cpu-count 8", "--dns=8.8.8.8")

#Just to update the modules to my local latest uncommitted version to be able to test them
#import-module "$env:USERPROFILE\Dropbox\GitHub\Cloud.Ready.Software.PowerShell\PSModules\CRS.RemoteNAVDockerHostHelper\CRS.RemoteNAVDockerHostHelper.psm1" -Force -WarningAction SilentlyContinue

#Load all functions
# Get-ChildItem (Join-Path $PSScriptRoot "Functions") -Filter "*.ps1" | % {
#     . $_.FullName
# }