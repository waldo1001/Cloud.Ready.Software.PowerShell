$artifactUrl = "https://bcartifacts.azureedge.net/businesscentral/onprem/2004-cu2-be"

$credential = New-Object pscredential 'waldo', (ConvertTo-SecureString -String 'Waldo1234' -AsPlainText -Force)
New-BcContainer `
    -accept_eula `
    -artifactUrl $artifactUrl `
    -containerName "test" `
    -auth "UserPassword" `
    -Credential $credential `
    -updateHosts
