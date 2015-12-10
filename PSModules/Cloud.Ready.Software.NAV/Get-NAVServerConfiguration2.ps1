function Get-NAVServerConfiguration2
{
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$ServerInstance
    )
    BEGIN
    {
        $ResultObjectArray =  @()          
        
    }
    PROCESS
    {   
        $CurrentServerInstance = Get-NAVServerInstance -ServerInstance $ServerInstance
        $CurrentConfig = $CurrentServerInstance | Get-NAVServerConfiguration -AsXml
        
        foreach ($Setting in $CurrentConfig.configuration.appSettings.add)
        {
            $ResultObject = New-Object System.Object
            $ResultObject | Add-Member -type NoteProperty -name ServiceInstance -value $CurrentServerInstance.ServerInstance
            $ResultObject | Add-Member -type NoteProperty -name Key -value $Setting.Key
            $ResultObject | Add-Member -Type NoteProperty -Name Value -Value $Setting.Value
            $ResultObjectArray += $ResultObject
        }

    }
    END
    {
        $ResultObjectArray
    }
}
