$BaseName = 'PerfTest'
$bcpt_appinsights = "InstrumentationKey=444af6dc-a16c-4b09-8c39-3beeec98a6b7;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/"


$containerName = "$($BaseName)"

Invoke-ScriptInBcContainer -containerName $containerName -scriptblock {

    param
    (
        $bcpt_appinsights
    )

    install-packageprovider -name NuGet -MinimumVersion 2.8.5.201 -Force
    install-module MSAL.PS -force
    Install-Module alops.externaldeployer -force
    import-module ALOps.ExternalDeployer
    Install-ALOpsExternalDeployer

    Write-Host "*** Uninstall ANY and Dependencies"
    Uninstall-NAVApp -ServerInstance BC -Publisher "Microsoft" -Name "Any" -Force:$true -ErrorAction:SilentlyContinue

    Write-Host "*** Uninstall Test-Upgrade and Dependencies"
    Uninstall-NAVApp -ServerInstance BC -Publisher "Microsoft" -Name "Tests-Upgrade" -Force:$true -ErrorAction:SilentlyContinue

    Write-Host "*** Check for remaining Test-Apps"
    $TestApps = Get-NAVAppInfo -ServerInstance BC -Tenant default -TenantSpecificProperties
    $TestAppsExists = $TestApps | Where-Object { $_.IsInstalled -and $_.Name.ToUpper().Contains("TEST") -and $_.Name -ne "Test Runner" }
    if ($null -ne $TestAppsExists){
        Write-Host "$($TestAppsExists | Format-List | Out-String)"
        Write-Error "*** Test CUs still exist"
    }

    Set-NAVServerConfiguration -ServerInstance "BC" `
                                -KeyName  EnableLockTimeoutMonitoring  `
                                -KeyValue $true

    Set-NAVServerConfiguration -ServerInstance "BC" `
                                -KeyName  EnableDeadlockMonitoring  `
                                -KeyValue $true
   
    Set-NAVServerConfiguration -ServerInstance "BC" `
                                -KeyName  SqlLongRunningThresholdForApplicationInsights  `
                                -KeyValue 500
   
    Set-NAVServerConfiguration -ServerInstance "BC" `
                                -KeyName  ALLongRunningFunctionTracingThresholdForApplicationInsights  `
                                -KeyValue 10000

    Set-NAVServerConfiguration -ServerInstance "BC" -KeyName "ApplicationInsightsConnectionString" -KeyValue $bcpt_appinsights -ApplyTo All
    
    Set-NAVServerInstance -ServerInstance "BC" -Restart

    Get-navserverconfiguration -ServerInstance "BC"



} -argumentList $bcpt_appinsights