function Get-NAVServerInstance2
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [System.String]
        $ServerInstance
    )
    
    process {
        $ServerInstanceObjects = Get-NAVServerInstance -ServerInstance $ServerInstance
        
        foreach ($ServerInstanceObject in $ServerInstanceObjects) {
            $ServerInstanceObject | Add-member -MemberType NoteProperty -Name 'Multitenant' -Value (Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance | Where Key -eq Multitenant).Value
            $ServerInstanceObject | Add-member -MemberType NoteProperty -Name 'ClientServicesPort' -Value (Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance | Where Key -eq ClientServicesPort).Value
            $ServerInstanceObject | Add-member -MemberType NoteProperty -Name 'DatabaseName' -Value (Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance | Where Key -eq DatabaseName).Value
            $ServerInstanceObject | Add-member -MemberType NoteProperty -Name 'DatabaseServer' -Value (Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance | Where Key -eq DatabaseServer).Value
            $ServerInstanceObject | Add-member -MemberType NoteProperty -Name 'DatabaseInstance' -Value (Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance | Where Key -eq DatabaseInstance).Value
                    
            $ServerInstanceObject
        }
            
        
    }
       
    
}

