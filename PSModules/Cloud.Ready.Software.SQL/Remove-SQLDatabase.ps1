function Remove-SQLDatabase
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Object]
        $DatabaseServer = [net.dns]::GetHostName(),
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $DatabaseInstance = '',

        [Parameter(Mandatory=$true, Position=2)]
        [Object]
        $DatabaseName
    )
    
    try{
        $null = import-module sqlps -WarningAction SilentlyContinue
        if (!([string]::IsNullOrEmpty($DatabaseInstance))){
            $DatabaseServer = "$($DatabaseServer)\$($DatabaseInstance)"
        }

        $server = New-Object Microsoft.SqlServer.Management.Smo.Server($DatabaseServer)   
        $server.databases[$DatabaseName].Drop()
    } Catch {
        try {
            Invoke-SQL -SQLCommand "ALTER DATABASE [$DatabaseName] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE"
            Invoke-SQL -SQLCommand "DROP DATABASE [$DatabaseName]"
        } catch {
            write-error "Unable to drop database $DatabaseName"
            write-error $Error[0]
            break
        }
    }
    
    write-Host -ForegroundColor Green "$DatabaseName successfully dropped."
}

