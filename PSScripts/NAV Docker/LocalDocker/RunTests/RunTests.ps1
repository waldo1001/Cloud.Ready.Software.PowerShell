. (Join-Path $PSScriptRoot '..\_Settings.ps1')

Run-TestsInNavContainer `
    -containerName "bconprem" `
    -credential $ContainerCredential `
    -testSuite 'DEFAULT' `
    -XUnitResultFileName 'c:\programdata\navcontainerhelper\bconprem.tests.results.xml' `
    -azuredevops error `
    -verbose