#The App
$WorkingFolder = 'C:\_NAVAppsWorkingFolder'

$CurrentApp = 'WaldoApp'
$OriginalDB = 'NAVApp_Original'
$navAppName = $CurrentApp
$navAppFolder = join-path $WorkingFolder $navAppName
$DevelopmentDB = 'NAVApp_DEV'

#Target
$TargetServerInstance = 'NAVAPP_QA_MT'
$TargetAppDB = 'NAVAPP_QA_MT_Application'
$TargetTenant = 'Default'


# Import References
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\Microsoft.Dynamics.Nav.Apps.Management.psd1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Apps.Tools.psd1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'

#load needed functions
Get-ChildItem 'S:\PowerShellScripts\PSFunctions' -Recurse -File | foreach {import-module $_.fullname}

$AppPackage = Package-NAVApp -AppName $navAppName -BuildFolder $navAppFolder -OriginalDatabase $OriginalDB -ModifiedDatabase $DevelopmentDB -Verbose

# Install NAV Package
$StartedDateTime = Get-Date

Write-Host 'Installing NavX Package.. ' -ForegroundColor Green

$InstalledApps = Get-NAVAppInfo -ServerInstance $TargetServerInstance 
$myApp = Get-NAVAppInfo -Path $AppPackage.PackageFile

$RemoveApp = $InstalledApps | where Description -eq $MyApp.Description
if ($RemoveApp){
    $RemoveApp | Uninstall-navapp -ServerInstance $TargetServerInstance -Tenant $TargetTenant 
    $RemoveApp | UnPublish-navapp -ServerInstance $TargetServerInstance 
}

Publish-NAVApp -Path $AppPackage.PackageFile -ServerInstance $TargetServerInstance
$myApp | Install-NAVApp -ServerInstance $TargetServerInstance -Tenant $TargetTenant

Sync-NAVTenant -ServerInstance $TargetServerInstance -Tenant $TargetTenant -Force -Mode Sync

$CompanyName = (Get-NAVCompany -ServerInstance $TargetServerInstance -Tenant $TargetTenant)[0].CompanyName
$StoppedDateTime = Get-Date

Write-Host 'Total Duration' ([Math]::Round(($StoppedDateTime - $StartedDateTime).TotalSeconds)) 'seconds' -ForegroundColor Green

Start-NAVWindowsClient -ServerName ([net.dns]::GetHostName()) -ServerInstance $TargetServerInstance -Companyname $CompanyName

