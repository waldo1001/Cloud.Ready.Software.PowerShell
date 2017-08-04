<#
.Synopsis
   Alternative for exporting objects: only have to provide the ServerInstance
.DESCRIPTION
   The serverinstance provides the details for exporting the objects.
   Assumes that the function is executed on the host where the ServerInstance is installed
   
#>
function Export-NAVApplicationObject2 {
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogPath,
        [Parameter(Mandatory=$false)]
        [String] $Filter,
        [Parameter(Mandatory=$false)]
        [switch] $ExportToNewSyntax,
        [Parameter(Mandatory=$false)]
        [switch] $ExportTxtSkipUnlicensed

    )
    
    process{
        $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

        $DatabaseServer =  $ServerInstanceObject.DatabaseServer
        if (!([string]::IsNullOrEmpty($ServerInstanceObject.DatabaseInstance))){
            $DatabaseServer += "\$($ServerInstanceObject.DatabaseInstance)"
        }

        Export-NAVApplicationObject `
            -DatabaseName $ServerInstanceObject.DatabaseName `
            -DatabaseServer $DatabaseServer `
            -Path $Path `
            -LogPath $LogPath `
            -Filter $Filter `
            -ExportToNewSyntax:$ExportToNewSyntax `
            -ExportTxtSkipUnlicensed:$ExportTxtSkipUnlicensed
        
    }
}