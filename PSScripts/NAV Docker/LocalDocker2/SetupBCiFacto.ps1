. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ContainerName = 'bcifacto'
$imageName = 'dtr.ifacto.be/distri:onprem-18.0.23013.23795-be-ltsc2019'

$includeTestToolkit = $false
$includeTestLibrariesOnly = $false

$StartMs = Get-date

New-BcContainer `
    -accept_eula `
    -containerName $ContainerName  `
    -imageName $imageName `
    -Credential $ContainerCredential `
    -auth "UserPassword" `
    -updateHosts `
    -alwaysPull `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -licenseFile $SecretSettings.containerLicenseFile 

 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
