<#
STEP 1
Create an isolated environment in which we will convert the code
#>

$ContainerName = 'tempdev'
$imageName = 'microsoft/dynamics-nav:devpreview-finus'
$licenseFile = 'C:\ProgramData\NavContainerHelper\NAV2018License.flf'

$UserName = 'NAVUser'
$Password = ConvertTo-SecureString "NAVUser123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$additionalParameters = @("--network=tlan", "--ip 172.21.31.9")

New-NavContainer `
    -accept_eula `
    -containerName $ContainerName `
    -imageName $imageName `
    -licenseFile $licenseFile `
    -auth NavUserPassword `
    -Credential $Credential `
    -doNotExportObjectsToText `
    -additionalParameters $additionalParameters