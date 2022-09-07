. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -type Sandbox `
    -version 19.3
    
    
$ContainerName = 'bcspecific'

# $featureKeys = @{
#     ActionBarDialogEarlyOverflow               = "None"
#     DisableIntegrationManagement               = "None"
#     EmailHandlingImprovements                  = "None"
#     JournalErrorBackgroundCheck                = "None"
#     PaymentReconciliationJournalUXImprovements = "None" 
# }

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
    -assignPremiumPlan `
    -isolation hyperv `
    -multitenant:$false `
    # -myScripts @("https://raw.githubusercontent.com/tfenster/nav-docker-samples/swaggerui/AdditionalSetup.ps1")
    # -imageName $imageName `


$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
