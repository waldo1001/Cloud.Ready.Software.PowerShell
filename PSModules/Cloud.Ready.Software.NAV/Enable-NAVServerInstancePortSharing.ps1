function Enable-NAVServerInstancePortSharing
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [System.String]
        $ServerInstance
    )
    process {
        $ServiceName = (get-navserverinstance -ServerInstance $ServerInstance).ServerInstance
        if (!($ServiceName)){
            Write-Error "$Serverinstance not found as an NAV ServerInstance."  
            return $null  
        }

        write-Host -ForegroundColor Green "Enabling PortSharing for $ServerInstance"
        Set-NAVServerInstance -ServerInstance $ServerInstance -Stop -ErrorAction SilentlyContinue

        $null = sc.exe config (get-service NetTcpPortSharing).Name Start= Auto
        $null = Start-service NetTcpPortSharing
    
        $Service = get-service  $ServiceName 
        $null = sc.exe config $Service.Name depend= HTTP/NetTcpPortSharing
    
        Set-NAVServerInstance -ServerInstance $ServerInstance -Start 
    }
}