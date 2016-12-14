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
        write-Host -ForegroundColor Green "Enabling PortSharing for $ServerInstance"
        Set-NAVServerInstance -ServerInstance $ServerInstance -Stop -ErrorAction SilentlyContinue

        $null = sc.exe config (get-service NetTcpPortSharing).Name Start= Auto
        $null = Start-service NetTcpPortSharing
    
        $Service = get-service  "*$ServerInstance*"
        if ($Service.Count -gt 1){$Service = get-service  "*MicrosoftDynamicsNavServer*$ServerInstance*"}
        $null = sc.exe config $Service.Name depend= HTTP/NetTcpPortSharing
    
        Set-NAVServerInstance -ServerInstance $ServerInstance -Start 
    }
}

