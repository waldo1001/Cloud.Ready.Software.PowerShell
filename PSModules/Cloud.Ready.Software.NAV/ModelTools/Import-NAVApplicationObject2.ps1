<#
.Synopsis
   Alternative for importing objects: only have to provide the ServerInstance
.DESCRIPTION
   The serverinstance provides the details for importing the objects.
   Assumes that the function is executed on the host where the ServerInstance is installed
   
#>
function Import-NAVApplicationObject2 {
    param (        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Fullname')] 
        [String] $Path,
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$false)]
        [String] $LogPath,
        [Parameter(Mandatory=$false)]
        [String] $Filter,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Default','Overwrite','Skip')]
        [String] $ImportAction = 'Default',
        [Parameter(Mandatory=$false)]
        [ValidateSet('Force','No','Yes')]
        [String] $SynchronizeSchemaChanges = 'Yes',
        [Parameter(Mandatory=$false)]
        [String] $NavServerName = ([net.dns]::GetHostName()),
        [Parameter(Mandatory=$false)]
        [Switch] $Confirm = $false

    )
    
    process{
        $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

        Import-NAVApplicationObject ` `            -Path $Path `
            -DatabaseName $ServerInstanceObject.DatabaseName `            -DatabaseServer $ServerInstanceObject.DatabaseServer `            -LogPath $LogPath `
            -ImportAction $ImportAction `            -SynchronizeSchemaChanges $SynchronizeSchemaChanges `            -NavServerInstance $ServerInstanceObject.ServerInstance `            -NavServerName $NavServerName `            -NavServerManagementPort $ServerInstanceObject.ManagementServicesPort `            -Confirm:$Confirm           
        
    }
}