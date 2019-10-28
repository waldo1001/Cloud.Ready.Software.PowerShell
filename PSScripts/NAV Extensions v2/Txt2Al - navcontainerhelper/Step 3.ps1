<#
STEP 3
Apply Delta to database & export as new syntax
#>

$ContainerName = 'tempdev'
$DeltaPath = 'C:\ProgramData\NavContainerHelper\Migration\DELTA'

$UserName = 'sa'
$Password = ConvertTo-SecureString "NAVUser123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

Import-DeltasToNavContainer -containerName $ContainerName -deltaFolder $DeltaPath -sqlCredential $Credential

Compile-ObjectsInNavContainer -containerName $ContainerName `
    -filter "Modified=1" `
    -sqlCredential $Credential
