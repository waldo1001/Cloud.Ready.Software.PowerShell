function Copy-NAVTenant
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]
        $ServerInstance,
        
        [Parameter(Mandatory=$true, Position=1)]
        [System.String]
        $CopyFromTenantID,
        
        [Parameter(Mandatory=$true, Position=2)]
        [System.String]
        $CopyToTenantID
    )
    
    $TenantExists = Get-NAVTenant -ServerInstance $ServerInstance -Tenant $CopyToTenantID
    if ($TenantExists) {
        Write-Error "Tenant $CopyToTenantID already exists!"
        break
    }
    
    $ServerInstanceObject = Get-NAVServerInstance2 -ServerInstance $ServerInstance
    $TenantObject = $ServerInstanceObject | Get-NAVTenant -Tenant $CopyFromTenantID 
    $BackupFileName = 'Backup.Bak'
    
    $BackupFile = Backup-SQLDatabaseToFile -DatabaseServer $TenantObject.DatabaseServer -DatabaseName $TenantObject.DatabaseName -BackupFile $BackupFileName 
    
    Restore-SQLBackupFile -BackupFile $BackupFile -DatabaseServer $TenantObject.DatabaseServer -DatabaseName $CopyToTenantID 
    remove-item $BackupFile -Force
    
    Mount-NAVTenant -ServerInstance $ServerInstance -DatabaseServer $TenantObject.DatabaseServer -DatabaseName $CopyToTenantID -Id $CopyToTenantID 
    Sync-NAVTenant -ServerInstance $ServerInstance -Tenant $CopyToTenantID -Mode Sync -Force
}

