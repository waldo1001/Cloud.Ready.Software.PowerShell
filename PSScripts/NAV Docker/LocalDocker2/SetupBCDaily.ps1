. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -country be `
    -sasToken $SecretSettings.InsiderSASToken `
    -select Latest `
    -storageAccount bcinsider

$ContainerName = 'bcdaily'
# $ImageName = $ContainerName

$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
$includeTestFrameworkOnly = $false
$includePerformanceToolkit = $true
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
    -assignPremiumPlan `
    -isolation hyperv `
    -multitenant:$false
    # -imageName $imageName `

if (!$includeTestLibrariesOnly) {
    UnInstall-BcContainerApp -containerName bcdaily -name "Tests-TestLibraries"
    # UnInstall-BcContainerApp -containerName bcdaily -name "Tests-Misc"
}

if ($includePerformanceToolkit) {
    $BCPTFolder = "C:\bcartifacts.cache\sandbox\20.0.37400.0\platform\Applications\testframework\performancetoolkit"
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

Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
    Set-NAVServerConfiguration `
        -KeyName "ServicesDefaultCompany" `
        -KeyValue "" `
        -ServerInstance BC

    Set-NAVServerInstance -ServerInstance BC -Restart    
}
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"