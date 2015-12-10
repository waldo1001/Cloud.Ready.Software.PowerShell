#Parameters
$ServerInstanceName = "DemoMTEnvironment"         #The current ServiceInstance
$DatabaseServer     = "localhost"                 #The Database Server where the database is located
$Databasename       = "DemoMTEnvironment"         #The database that will be migrated to Multi-Tenancy       
$PathToDVD          = 'C:\_PowerShell\Workshop\'  #The path to the DVD
$ApplicationDB      = "DemoApplicationDB"

#The Script
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1' | Out-Null
import-module "$PathToDVD\WindowsPowerShellScripts\Multitenancy\NAVMultitenancySamples" -WarningAction SilentlyContinue | Out-Null

$CurrentServerInstance = Get-NAVServerInstance -ServerInstance $ServerInstanceName
$MainTenant = "MainTenant"	
	
Write-host "Split the Application Database and Customer Data"
Export-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $Databasename -DestinationDatabaseName $ApplicationDB -Force
Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $Databasename -Force
	
Write-host "Prepare NST for MultiTenancy"
$CurrentServerInstance | Set-NAVServerInstance -stop
$CurrentServerInstance | Set-NAVServerConfiguration -KeyName MultiTenant -KeyValue "true"
$CurrentServerInstance | Set-NAVServerConfiguration -KeyName DatabaseName -KeyValue ""
$CurrentServerInstance | Set-NAVServerInstance -start
	
Write-host "Mount app"
$CurrentServerInstance | Mount-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName  $ApplicationDB 
	
Write-host "Mount $MainTenant"
Mount-NAVTenant -ServerInstance $ServerInstanceName -Id $MainTenant -DatabaseName $Databasename -AllowAppDatabaseWrite -OverwriteTenantIdInDatabase
	
Write-host "Create Tenants and move companies"
Write-host "Move PRS Companies"
$MoveToTenant = 'Demo PRS Company'
$CurrentServerInstance | `    Get-NAVCompany -Tenant $MainTenant | `        Where-Object { $_."CompanyName" -like $MoveToTenant + '*' } | `            HowTo-MoveCompanyToTenant `                    -ServerInstance $CurrentServerInstance.ServerInstance `                    -FromDatabase $Databasename `                    -OldTenantName $MainTenant `                    -NewTenantName $MoveToTenant.Replace(" ","") `                    -RemoveCompanyWhenMoved `
                    -WarningAction SilentlyContinue 
	
Write-host "Move Waldo Companies"
$MoveToTenant = 'Demo Waldo Company'
$CurrentServerInstance | `    Get-NAVCompany -Tenant $MainTenant | `        Where-Object { $_."CompanyName" -like $MoveToTenant + '*' } | `            HowTo-MoveCompanyToTenant `                    -ServerInstance $CurrentServerInstance.ServerInstance `                    -FromDatabase $Databasename `                    -OldTenantName $MainTenant `                    -NewTenantName $MoveToTenant.Replace(" ","") `
                    -RemoveCompanyWhenMoved `
                    -WarningAction SilentlyContinue 
