function Get-NAVCompany2
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$ServerInstance,
        [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [String]$Id="Default"
    )
    PROCESS
    {   
        $CurrentTenant = Get-NAVTenant -ServerInstance $ServerInstance -Tenant $Id
        $AllCompaniesInTenant = $CurrentTenant | Get-NAVCompany
        
        foreach ($Company in $AllCompaniesInTenant)
        {
            $Company | Add-Member -type NoteProperty -name ServerInstance -value $CurrentTenant.ServerInstance
            $Company | Add-Member -type NoteProperty -name Tenant -value $CurrentTenant.Id
            
            $Company
        }
    }
}

