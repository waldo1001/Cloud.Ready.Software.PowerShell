#Parameters
$ServerInstanceName = "DemoMTEnvironment"         #The current ServiceInstance
$DatabaseServer     = "localhost"                 #The Database Server where the database is located
$Databasename       = "DemoMTEnvironment"         #The database that will be migrated to Multi-Tenancy
$DemoCompanyName    = "CRONUS BELGIË NV"          #This company will be renamed to "MainCompany".  The data of this company will be available in the Mult-Tenancy environment.
$PathToDVD          = 'C:\_PowerShell\Workshop\'  #The path to the DVD
$MainCompanyName    = "Default Company"
$ApplicationDB      = "DemoApplicationDB"


#The script
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1' | Out-Null
import-module "$PathToDVD\WindowsPowerShellScripts\Multitenancy\NAVMultitenancySamples" -WarningAction SilentlyContinue | Out-Null

#load "drop-sqldatabaseifexist" from current directory
. (Join-Path $PSScriptRoot 'Drop-SQLDatabaseIfExists.ps1')

$MainCompanyName = "MainCompany"
$MainTenant = "MainTenant"

#Remove MT Environment	
Write-host "Removing environment"
$NAVTenants = Get-NAVTenant -ServerInstance $ServerInstanceName -ErrorAction SilentlyContinue
foreach ($NAVTenant in $NAVTenants) {
    Drop-SQLDatabaseIfExists "localhost" $NAVTenant.Databasename
}

Drop-sqldatabaseifexists "localhost" $ApplicationDB
Remove-NAVServerInstance -ServerInstance $ServerInstanceName -ErrorAction SilentlyContinue -Force
Drop-SQLDatabaseIfExists "localhost" $Databasename


