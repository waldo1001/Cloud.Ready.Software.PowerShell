<#
.Synopsis
   Executes a SQL Statement on the database server of an NAV ServerInstance
.DESCRIPTION
   Will return an object model when records were retrieved
.NOTES
   
.PREREQUISITES
   Use Microsoft.Dynamics.NAV.Management module
   Uses Get-NAVServerInstanceDetails
#>


function Invoke-NAVSQL {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$true)]
        [string] $SQLCommand = ''
      )

    Write-Verbose "Invoke-NAVSQL $ServerInstance $SQLCommand"
     
    $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

    Invoke-SQL `        -DatabaseServer $ServerInstanceObject.DatabaseServer `        -DatabaseInstance $ServerInstanceObject.DatabaseInstance `        -DatabaseName $ServerInstanceObject.DatabaseName
     
}