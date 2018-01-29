<#
enter-pssession waldocorevm -Credential (Get-Credential)
#>

. (join-path $PSScriptRoot '_Settings.ps1')

$DockerImage = 'navdocker.azurecr.io/dynamics-nav:devpreview'
$Servername = 'devpreview'
$IPAddress = '172.21.31.4'
$AlwaysPull = $false

Invoke-Command -ComputerName $DockerHost -Credential (Get-Credential) -ScriptBlock {
    param(
        $Servername,$IPAddress,$DockerImage,$LicenseFile,$Memory,[System.Management.Automation.PSCredential] $Credential, [bool] $AlwaysPull
    )

    New-NavContainer `
        -accept_eula `
        -containerName $Servername `
        -imageName $DockerImage `
        -licenseFile $LicenseFile `
        -doNotExportObjectsToText `
        -additionalParameters @("--network=tlan","--ip $IPAddress") `
        -memoryLimit $Memory `
        -alwaysPull:$AlwaysPull `
        -updateHosts `
        -auth NavUserPassword `
        -includeCSide `
        -Verbose `
        -Credential $Credential 
} -ArgumentList $Servername,$IPAddress,$DockerImage,$LicenseFile,$Memory,$Credential,$AlwaysPull


Start-Process "http://$($Servername):8080/"
