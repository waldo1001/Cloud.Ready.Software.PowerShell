. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -country be `
    -storageAccount bcpublicpreview `
    -select Latest

$ContainerName = 'bcpublicreview'
$ImageName = $ContainerName

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true

$StartMs = Get-date

New-BcContainer `
    -accept_eula `
    -containerName $ContainerName  `
    -artifactUrl $artifactUrl `
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
