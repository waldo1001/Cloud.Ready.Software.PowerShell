. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    -version 21.1 `
    -country w1

$ContainerName = 'dxsteel'
# $ImageName = $ContainerName

$SecretSettings.containerLicenseFile = "https://www.dropbox.com/s/fc18q7g6f57ajbx/LicenseiFactoNL.flf?dl=1"

$databasename = 'mydatabase'
$bakFile = "C:\Temp\DxSteel\BC21NL_dxsteel_20230111_1102\BC21NL_dxsteel_20230111_1102.bak"
$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
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
    -bakFile $bakFile
    # -imageName $imageName `

break

Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
    write-host "Removing all users from the database" -ForegroundColor Green

    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User]" 
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[Access Control]"
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Property]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[Page Data Personalization]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Default Style Sheet]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Metadata]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Personalization]" 
    
    write-host "Copy DLLs" -ForegroundColor Green
    copy -path "C:\ProgramData\BcContainerHelper\DxSteel\Add-ins\*.*" -Destination "C:\Program Files\Microsoft Dynamics NAV\190\Service\Add-ins" -Recurse -Force

    write-host "Restart NST" -ForegroundColor Green
    Set-NAVServerInstance -ServerInstance bc -Restart

    write-host "Create waldo-user" -ForegroundColor Green
    $Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
    New-NAVServerUser -UserName 'waldo' -Password $Password -ServerInstance BC
} 
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"
