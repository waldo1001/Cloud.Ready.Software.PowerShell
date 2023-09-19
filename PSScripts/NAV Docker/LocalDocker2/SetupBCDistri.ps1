. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$artifactUrl = Get-BCArtifactUrl `
    -Type Sandbox `
    -version 21.2 `
    -country be

$ContainerName = 'bcdistri'
# $ImageName = $ContainerName

$bakFile = "C:\Temp\Distri\Merged_BC_DISTRI_MASTER_QA.bak"
# $bakFile = "C:\bcartifacts.cache\sandbox\21.2.49946.52251\be\BusinessCentral-BE.bak"
$includeTestToolkit = $true
$includeTestLibrariesOnly = $true
$includeTestFrameworkOnly = $true
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

Invoke-ScriptInBcContainer -containerName $ContainerName -scriptblock {
    write-host "Removing all users from the database" -ForegroundColor Green

    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User]" 
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[Access Control]"
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Property]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[Page Data Personalization]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Default Style Sheet]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Metadata]"    
    Invoke-Sqlcmd -database 'mydatabase' -Query "delete from [dbo].[User Personalization]" 
    
    write-host "Restart NST" -ForegroundColor Green
    Set-NAVServerInstance -ServerInstance bc -Restart

    write-host "Create waldo-user" -ForegroundColor Green
    $Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
    New-NAVServerUser -UserName 'waldo' -Password $Password -ServerInstance BC
} 
 
$EndMs = Get-date
Write-host "This script took $(($EndMs - $StartMs).TotalSeconds) seconds to run"
