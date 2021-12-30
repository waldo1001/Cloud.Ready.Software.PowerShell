. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -country de `
    -type Sandbox `
    -version 16.5
    
    
$ContainerName = 'bcspecific'
$ImageName = $ContainerName

# $featureKeys = @{
#     ActionBarDialogEarlyOverflow               = "None"
#     DisableIntegrationManagement               = "None"
#     EmailHandlingImprovements                  = "None"
#     JournalErrorBackgroundCheck                = "None"
#     PaymentReconciliationJournalUXImprovements = "None" 
# }

$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$enableSymbolLoading = $false

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
    -licenseFile $SecretSettings.containerLicenseFile `
    -featureKeys $featureKeys `
    -enableSymbolLoading:$enableSymbolLoading


$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
