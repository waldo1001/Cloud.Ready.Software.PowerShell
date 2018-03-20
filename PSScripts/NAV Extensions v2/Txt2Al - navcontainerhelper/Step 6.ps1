<#
STEP 6
Convert to New Syntax
#>

$ContainerName = 'tempdev'

$UserName = 'sa'
$Password = ConvertTo-SecureString "NAVUser123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

Convert-ModifiedObjectsToAl -containerName $ContainerName -startId 50110 -sqlCredential $Credential -Verbose -filter ""

