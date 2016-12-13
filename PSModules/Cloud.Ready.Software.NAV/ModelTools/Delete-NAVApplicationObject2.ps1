<#
.Synopsis
   Alternative for Deleting objects: only have to provide the ServerInstance
.DESCRIPTION
   The serverinstance provides the details for Deleting the objects.
   Assumes that the function is executed on the host where the ServerInstance is installed
   
#>
function Delete-NAVApplicationObject2 {
    param (        
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$false)]
        [String] $LogPath,
        [Parameter(Mandatory=$false)]
        [String] $Filter,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Force','No','Yes')]
        [String] $SynchronizeSchemaChanges = 'Yes',
        [Parameter(Mandatory=$false)]
        [Switch] $Confirm = $true `        
    )
    
    process{
        $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance
        
        $DatabaseServer =  $ServerInstanceObject.DatabaseServer
        if (!([string]::IsNullOrEmpty($ServerInstanceObject.DatabaseInstance))){
            $DatabaseServer += "\$($ServerInstanceObject.DatabaseInstance)"
        }

        Delete-NAVApplicationObject `
            -DatabaseName $ServerInstanceObject.DatabaseName `            -DatabaseServer $ServerInstanceObject.DatabaseServer `            -LogPath $LogPath `            -SynchronizeSchemaChanges $SynchronizeSchemaChanges `            -NavServerInstance $ServerInstanceObject.ServerInstance `            -NavServerName ([net.dns]::GetHostName()) `            -NavServerManagementPort $ServerInstanceObject.ManagementServicesPort `            -Filter $Filter `
            -Confirm:$Confirm

    }
}