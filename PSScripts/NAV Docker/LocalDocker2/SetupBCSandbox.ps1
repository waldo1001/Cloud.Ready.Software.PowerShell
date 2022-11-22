. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type Sandbox `
    -Select Latest `
    -country be 

$ContainerName = 'bcsandbox'
$ImageName = $ContainerName

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$includeTestFrameworkOnly = $false
$includePerformanceToolkit = $false

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
    -includeTestFrameworkOnly:$includeTestFrameworkOnly `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -includePerformanceToolkit:$includePerformanceToolkit `
    -licenseFile $SecretSettings.containerLicenseFile `
    -enableTaskScheduler 


if (!$includeTestLibrariesOnly -and !$includeTestFrameworkOnly) {
    UnInstall-BcContainerApp -containerName $ContainerName -name "Performance Toolkit"
    UnPublish-BcContainerApp -containerName $ContainerName -name "Performance Toolkit Tests" -force
    UnPublish-BcContainerApp -containerName $ContainerName -name "Performance Toolkit" -force
}


$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"


