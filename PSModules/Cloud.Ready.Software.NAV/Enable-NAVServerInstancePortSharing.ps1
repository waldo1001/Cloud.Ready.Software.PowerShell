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
    
        $null = sc.exe config (get-service  "*$ServerInstance*").Name depend= HTTP/NetTcpPortSharing
    
        Set-NAVServerInstance -ServerInstance $ServerInstance -Start 
    }
}

