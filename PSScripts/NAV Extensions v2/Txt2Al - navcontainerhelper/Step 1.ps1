<#
STEP 1
Create an isolated environment in which we will convert the code
#>

$ContainerName = 'tempdev'
$imageName = 'mcr.microsoft.com/businesscentral/onprem'
#$imageName = 'microsoft/bcsandbox:base'
$licenseFile = 'https://www.dropbox.com/s/5cfyfnqdoyt23hi/_CRS%20-%206743401%20BC13%20W1.flf?dl=1'
$DeltaPath = 'C:\ProgramData\NavContainerHelper\Migration\DELTA'

$UserName = 'NAVUser'
$Password = ConvertTo-SecureString "NAVUser123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$ContainerAdditionalParameters = @("--env isBcSandbox=Y","--cpu-count 8","--dns=8.8.8.8")

New-NavContainer `
    -accept_eula `
    -containerName $ContainerName `
    -auth NavUserPassword `
    -credential $Credential `
    -includeCSide `
    -licensefile $licenseFile `
    -imageName $imageName `
    -updateHosts `
    -additionalParameters $ContainerAdditionalParameters `
    -accept_outdated 

