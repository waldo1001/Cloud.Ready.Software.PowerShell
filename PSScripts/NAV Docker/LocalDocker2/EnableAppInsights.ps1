$ContainerName = 'bccurrent'

Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {

    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName  ApplicationInsightsConnectionString `
        -KeyValue "InstrumentationKey=a9c6ebe8-d13b-421f-903d-8d0aeca0a0c5;IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/" `
        -verbose

    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName  EnableLockTimeoutMonitoring  `
        -KeyValue $true `
        -verbose

    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName  EnableDeadlockMonitoring  `
        -KeyValue $true `
        -verbose

    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName  SqlLongRunningThresholdForApplicationInsights  `
        -KeyValue 5 ` #way down? default: 750
        -verbose

    Set-NAVServerConfiguration `
        -ServerInstance "BC" `
        -KeyName  ALLongRunningFunctionTracingThresholdForApplicationInsights  `
        -KeyValue 1000000 ` #way up? default: 10000
        -verbose

    Set-NAVServerInstance -ServerInstance bc -Restart
} 
