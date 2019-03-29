$imageName = "mcr.microsoft.com/businesscentral/onprem:w1"
$credential = New-Object pscredential 'waldo', (ConvertTo-SecureString -String 'Waldo1234' -AsPlainText -Force)
$containerName = "bconprem"
New-NavContainer `
    -imageName $imageName `
    -containerName $containerName `
    -accept_eula `
    -updateHosts `
    -auth NavUserPassword `
    -Credential $credential `
    -includeCSide `
    -enableSymbolLoading `
    -includeTestToolkit `
    -licenseFile "C:\ProgramData\NavContainerHelper\license.flf"