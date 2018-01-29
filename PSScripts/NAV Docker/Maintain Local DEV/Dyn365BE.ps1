<#
enter-pssession waldocorevm -Credential (Get-Credential)
#>

. (join-path $PSScriptRoot '_Settings.ps1')

$DockerImage = 'navdocker.azurecr.io/dynamics-nav:11.0.20315.0-finbe'
$Servername = 'dyn365be'
$IPAddress = '172.21.31.7'
$AlwaysPull = $true

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
