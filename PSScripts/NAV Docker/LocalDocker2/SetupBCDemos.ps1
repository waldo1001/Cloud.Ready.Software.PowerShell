. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type Sandbox `
    -Select Weekly 

$ContainerName = 'demos'

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
    -alwaysPull:$true `
    -includeTestToolkit:$includeTestToolkit `
    -includeTestFrameworkOnly:$includeTestFrameworkOnly `
    -includeTestLibrariesOnly:$includeTestLibrariesOnly `
    -licenseFile $SecretSettings.containerLicenseFile `
    -enableTaskScheduler `
    -forceRebuild:$forceRebuild `
    -assignPremiumPlan `
    -isolation hyperv `
    -multitenant:$false `
    -includePerformanceToolkit:$includePerformanceToolkit
    # -myScripts @("https://raw.githubusercontent.com/tfenster/nav-docker-samples/swaggerui/AdditionalSetup.ps1") `
    # -imageName $imageName `

if ($includePerformanceToolkit) {
    #When Performance toolkig, you don't want this:

    write-host "Removing Performance killers" -foregroundcolor green
    UnInstall-BcContainerApp -containerName bccurrent -name "Tests-TestLibraries" -ErrorAction SilentlyContinue
    UnInstall-BcContainerApp -containerName bccurrent -name "Tests-Misc" -ErrorAction SilentlyContinue

    $BcContainerCountry = Get-BcContainerCountry -containerOrImageName $ContainerName
    $BcContainerArtifactUrl = Get-BcContainerArtifactUrl -containerName $ContainerName
    $BcContainerArtifactUrl = $BcContainerArtifactUrl -replace 'https://bcartifacts.azureedge.net/', 'C:/bcartifacts.cache/'
    $BcContainerArtifactUrl = $BcContainerArtifactUrl -replace 'https://bcinsider.azureedge.net/', 'C:/bcartifacts.cache/'
    $BcContainerArtifactUrl = $BcContainerArtifactUrl.Replace($SecretSettings.InsiderSASToken, '')
    $BcContainerArtifactUrl = $BcContainerArtifactUrl -replace $BcContainerCountry, 'platform'
    $PerformanceToolkitSamples = (Get-ChildItem -Recurse -Path $BcContainerArtifactUrl -Filter "*Microsoft_Performance Toolkit Samples.app*").FullName
    
    if ($PerformanceToolkitSamples) {             
        Publish-BcContainerApp `
        -containerName $ContainerName `
        -appFile $PerformanceToolkitSamples `
        -install `
        -sync `
        -syncMode ForceSync `
        -ignoreIfAppExists
    }

    Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {

        Write-Host "Setting SamplingInterval to 1" -foregroundcolor green
    
        Set-NAVServerConfiguration `
            -ServerInstance "BC" `
            -KeyName  SamplingInterval `
            -KeyValue 1 `
            -ApplyTo All `
            -verbose
    
        Set-NAVServerInstance -ServerInstance bc -Restart
    }
}
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"
