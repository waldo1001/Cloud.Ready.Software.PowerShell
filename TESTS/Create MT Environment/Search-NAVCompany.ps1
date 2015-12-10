function Search-NAVCompany($SearchCompany)
{
    Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'

    $ResultObjectArray =  @()

    $AllTenants = Get-NAVServerInstance | Get-NAVTenant
    foreach ($Tenant in $AllTenants)
    {
        $AllCompaniesInTenant = $Tenant | Get-NAVCompany | Where CompanyName -like "*$SearchCompany*"
        foreach ($Company in $AllCompaniesInTenant)
        {
            $ResultObject = New-Object System.Object
            $ResultObject | Add-Member -Type NoteProperty -Name CompanyName -Value $Company.CompanyName
            $ResultObject | Add-Member -type NoteProperty -name ServiceInstance -value $Tenant.ServerInstance
            $ResultObject | Add-Member -type NoteProperty -name Tenant -value $Tenant.Id
            $ResultObjectArray += $ResultObject
        }
    }

    $ResultObjectArray
 }