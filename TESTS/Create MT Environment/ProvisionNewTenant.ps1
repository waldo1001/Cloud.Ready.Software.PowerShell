#Parameters
$NewCompanyName     = "Demo Microsoft"
$NewTenantName      = $NewCompanyName.Replace(" ","")

#The Script
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1' | Out-Null
import-module "$PathToDVD\WindowsPowerShellScripts\Multitenancy\NAVMultitenancySamples" -WarningAction SilentlyContinue | Out-Null

#Constants
$ServerInstanceName       = "DemoMTEnvironment"         
$MainCompanyName          = "Default Company"
$MainTenant               = "MainTenant"
$MainTenantDatabaseServer = "localhost"            
$MainTenantDatabasename   = "DemoMTEnvironment"  
$PathToDVD                = 'C:\_PowerShell\Workshop\'  
$CurrentServerInstance    = Get-NAVServerInstance -ServerInstance $ServerInstanceName

#Create New Company in Main Tenant
Write-host "Creating Company ""$NewCompanyName"""
Copy-NAVCompany -ServerInstance $ServerInstanceName -Tenant $MainTenant -SourceCompanyName $MainCompanyName -DestinationCompanyName $NewCompanyName

Write-host "Moving Company ""$NewCompanyName"" to tenant ""$NewTenantName"""
$CurrentServerInstance | `    Get-NAVCompany -Tenant $MainTenant | `        Where-Object { $_."CompanyName" -eq $NewCompanyName } | `            HowTo-MoveCompanyToTenant `                    -ServerInstance $ServerInstanceName `                    -FromDatabase $MainTenantDatabasename `                    -OldTenantName $MainTenant `                    -NewTenantName $NewTenantName `
                    -RemoveCompanyWhenMoved `
                    -WarningAction SilentlyContinue 
                    
$RoletailoredCLient = "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe"
$ConnectionString = """DynamicsNAV://WIN-K5JLU49T31O:7746/DemoMTEnvironment/$NewCompanyName/?tenant=$NewTenantName"""
Start-Process -FilePath $RoletailoredCLient -ArgumentList $ConnectionString
