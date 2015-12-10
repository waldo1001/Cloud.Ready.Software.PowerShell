function Get-NAVServerInstance3
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
            $ServerConfigKeys = Get-NAVServerConfiguration2 -ServerInstance $ServerInstanceObject.ServerInstance 
        
            foreach($ServerConfigKey in $ServerConfigKeys) {
                $PropertyAlreadyExists = $ServerInstanceObject | Get-Member | Where Name -ieq $ServerConfigKey.Key
                if (-not ($PropertyAlreadyExists)){
                    $ServerInstanceObject | Add-member -MemberType NoteProperty -Name $ServerConfigKey.Key -Value $ServerConfigKey.Value
                }                        
            }

            $ServerInstanceObject
        }                    
                
    }
    
           
}
