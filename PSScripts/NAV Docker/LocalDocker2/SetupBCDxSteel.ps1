 (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    -version 19.1
    
$ContainerName = 'bcdxsteel'
$ImageName = $ContainerName
$bakfile = "C:\Temp\DxSteel\BC_DXSTEEL_QA_backup_2021_11_06_133820_9242168.BAK"

$includeTestToolkit = $false
$includeTestLibrariesOnly = $false

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
    -bakFile $bakfile 

Invoke-ScriptInNavContainer -containerName $ContainerName -scriptblock {
    new-navserveruser -serverinstance BC -UserName $UserName -Password $Password
} -argumentList $UserName, $password

$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).Seconds) seconds to run"
