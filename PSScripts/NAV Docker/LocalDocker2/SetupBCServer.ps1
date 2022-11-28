. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    # -select 'latest' `
    -version '18.4.28601.29139' `
    -country be

$ContainerName = 'bcserver'
$ImageName = $ContainerName

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$includeTestFrameworkOnly = $false
$includePerformanceToolkit = $true

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
    -enableTaskScheduler `
    # -forceRebuild

UnInstall-BcContainerApp -containerName $ContainerName -name "Tests-TestLibraries"
UnInstall-BcContainerApp -containerName $ContainerName -name "Tests-Misc"

Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName SqlLongRunningThreshold `
        -KeyValue 20 `
        -ApplyTo Memory

    Invoke-Sqlcmd -Query "alter DATABASE CRONUS
    SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE);"
    Invoke-Sqlcmd -Query "alter DATABASE CRONUS
    SET QUERY_STORE = ON (WAIT_STATS_CAPTURE_MODE = ON);"
}
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"


 