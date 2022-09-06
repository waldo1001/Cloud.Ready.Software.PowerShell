. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type Sandbox `
    -Select NextMajor `
    -sasToken $SecretSettings.InsiderSASToken

$ContainerName = 'bcdaily'
# $ImageName = $ContainerName

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$includeTestFrameworkOnly = $true
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
    -licenseFile $SecretSettings.containerLicenseFile `
    -enableTaskScheduler `
    -forceRebuild:$forceRebuild `
    -assignPremiumPlan `
    -isolation hyperv `
    -multitenant:$false `
    -myScripts @("https://raw.githubusercontent.com/tfenster/nav-docker-samples/swaggerui/AdditionalSetup.ps1")
    # -includePerformanceToolkit:$includePerformanceToolkit `
    # -imageName $imageName `

# if (!$includeTestLibrariesOnly) {
    UnInstall-BcContainerApp -containerName bccurrent -name "Tests-TestLibraries" -ErrorAction SilentlyContinue
    # UnInstall-BcContainerApp -containerName bccurrent -name "Tests-Misc"
# }

if ($includePerformanceToolkit) {
    $BCPTFolder = "C:\bcartifacts.cache\onprem\20.0.37253.38230\platform\Applications\testframework\performancetoolkit"
    Publish-BcContainerApp `
        -containerName $ContainerName `
        -appFile (join-path $BCPTFolder "Microsoft_Performance Toolkit.app") `
        -install `
        -sync `
        -syncMode ForceSync
    Publish-BcContainerApp `
        -containerName $ContainerName `
        -appFile (join-path $BCPTFolder "Microsoft_Performance Toolkit Samples.app") `
        -install `
        -sync `
        -syncMode ForceSync
}

# Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
#     Set-NAVServerConfiguration `
#         -ServerInstance "BC" `
#         -KeyName SqlLongRunningThreshold `
#         -KeyValue 20 `
#         -ApplyTo Memory

#     Invoke-Sqlcmd -Query "alter DATABASE CRONUS
#     SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE);"
#     Invoke-Sqlcmd -Query "alter DATABASE CRONUS
#     SET QUERY_STORE = ON (WAIT_STATS_CAPTURE_MODE = ON);"
# }
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
