#Parameters
$ServerInstanceName = "DemoMTEnvironment"         #The current ServiceInstance
$DatabaseServer     = "localhost"                 #The Database Server where the database is located
$Databasename       = "DemoMTEnvironment"         #The database that will be migrated to Multi-Tenancy
$DemoCompanyName    = "CRONUS BELGIË NV"          #This company will be renamed to "MainCompany".  The data of this company will be available in the Mult-Tenancy environment.
$PathToDVD          = 'C:\_PowerShell\Workshop\'             #The path to the DVD
$MainCompanyName    = "Default Company"
$ApplicationDB      = "DemoApplicationDB"

#Create New Database
Write-host "Restoring default db"
New-NavDatabase (Join-Path $PSScriptRoot '\NAV2015_DEFAULT.bak') –DatabaseName $Databasename -DatabaseServer $DatabaseServer -ErrorAction Stop

#Create Single Tenant Environment
Write-host "Create ServerInstance: $ServerInstanceName"
New-NAVServerInstance `
        -ServerInstance $ServerInstanceName `
        -ManagementServicesPort 7745 `
        -ClientServicesPort 7746 `
        -SOAPServicesPort 7747 `
        -ODataServicesPort 7748 `
        -DatabaseServer localhost `
        -DatabaseName $Databasename `
        -ErrorAction Stop


#Start Service
Set-NAVServerInstance $ServerInstanceName -Start

$CurrentServerInstance = Get-NAVServerInstance -ServerInstance $ServerInstanceName

Write-host "Preparing Companies - Rename and delete default companies"
$CurrentServerInstance | Rename-NAVCompany -CompanyName $DemoCompanyName -NewCompanyName $MainCompanyName -Force
$DemoCompanies = $CurrentServerInstance | Get-NAVCompany
foreach ($DemoCompany in $DemoCompanies)
{
  if (!($DemoCompany.CompanyName -like $MainCompanyName))
    {
        $CurrentServerInstance | Remove-NAVCompany -CompanyName $DemoCompany.CompanyName -Force
    }  
}
		
Write-host "Preparing Companies - Create a new company with data"
$CurrentServerInstance | Copy-NAVCompany -SourceCompanyName $MainCompanyName -DestinationCompanyName "Demo PRS Company Default" -Force
	
Write-host "Preparing Companies - Creating 2 empty Waldo Companies"
for ($i = 1; $i -le 2; $i++)
{ 
	$CompanyName = 'Demo Waldo Company'+$i
	$CurrentServerInstance | New-NAVCompany -CompanyName $CompanyName -Force
}
	
Write-host "Preparing Companies - Creating 3 empty PRS companies"
for ($i = 1; $i -le 3; $i++)
{ 
	$CompanyName = 'Demo PRS Company'+$i
	$CurrentServerInstance | New-NAVCompany -CompanyName $CompanyName -Force
}

Write-host "Opening Client"
$RoletailoredCLient = "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe"

$ConnectionString = """DynamicsNAV://WIN-K5JLU49T31O:7746/DemoMTEnvironment/$MainCompany/?tenant=Default"""
Start-Process -FilePath $RoletailoredCLient -ArgumentList $ConnectionString
