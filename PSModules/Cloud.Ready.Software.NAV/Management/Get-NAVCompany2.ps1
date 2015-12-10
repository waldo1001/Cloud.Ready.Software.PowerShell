function Get-NAVCompany2
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$ServerInstance,
        [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [String]$Id="Default"
    )
    BEGIN
    {
        $ResultObjectArray =  @()   
    }
    PROCESS
    {   
        $CurrentTenant = Get-NAVTenant -ServerInstance $ServerInstance -Tenant $Id
        $AllCompaniesInTenant = $CurrentTenant | Get-NAVCompany
        
        foreach ($Company in $AllCompaniesInTenant)
        {
            $ResultObject = New-Object System.Object
            $ResultObject | Add-Member -type NoteProperty -name ServerInstance -value $CurrentTenant.ServerInstance
            $ResultObject | Add-Member -type NoteProperty -name Tenant -value $CurrentTenant.Id
            $ResultObject | Add-Member -Type NoteProperty -Name CompanyName -Value $Company.CompanyName
            $ResultObjectArray += $ResultObject
        }
    }
    END
    {
        $ResultObjectArray
    }
}
