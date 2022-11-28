. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    -Select Latest `
    -country be #-version 17.5

$ContainerName = 'bccurrent'
$ImageName = $ContainerName

$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
$includePerformanceToolkit = $true

$StartMs = Get-date

New-BcContainer `
    -accept_eula `
    -containerName $ContainerName  `
    -artifactUrl $artifactUrl `
    -imageName $imageName `
    -auth Windows `
    -updateHosts `
    -alwaysPull `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -licenseFile $SecretSettings.containerLicenseFile `
    -includePerformanceToolkit:$includePerformanceToolkit `
    -enableTaskScheduler 



Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName SqlLongRunningThreshold `
        -KeyValue 2000 `
        -ApplyTo Memory
}
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"


