. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    -Select Latest

$ContainerName = 'bconprem'
$ImageName = $ContainerName

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$includeTestFrameworkOnly = $false
$includePerformanceToolkit = $false
$forceRebuild = $true

$StartMs = Get-date

New-BcContainer `
    -accept_eula `
    -containerName $ContainerName  `
    -artifactUrl $artifactUrl `
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
    -forceRebuild:$forceRebuild `
    -assignPremiumPlan
    # -imageName $imageName `

if (!$includeTestLibrariesOnly) {
    UnInstall-BcContainerApp -containerName bccurrent -name "Tests-TestLibraries"
    # UnInstall-BcContainerApp -containerName bccurrent -name "Tests-Misc"
}

if ($includePerformanceToolkit) {
    $BCPTFolder = "C:\bcartifacts.cache\onprem\18.2.26217.26490\platform\Applications\testframework\performancetoolkit"
    Publish-BcContainerApp `
        -containerName $ContainerName `
        -appFile (join-path $BCPTFolder "Microsoft_Performance Toolkit Samples.app") `
        -install `
        -sync `
        -syncMode ForceSync
}

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
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
