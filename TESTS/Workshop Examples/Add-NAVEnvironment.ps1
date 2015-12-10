function Add-NAVEnvironment {
    [CmdletBinding()]
    param(
        [String]$ServerInstance,
        [String]$DatabaseServer='.',
        [String]$DatabaseInstance='',
        [Parameter(Mandatory=$true)]
        [String]$Databasename='',
        [switch]$EnablePortSharing,
        [Switch]$StartWindowsClient,
        [Switch]$EnableJobQueue
    )

    $ServerInstanceExists = Get-NAVServerInstance -ServerInstance $ServerInstance
    if ($ServerInstanceExists) {
        Write-Error "Server Instance $ServerInstance already exists!"
        break
    }

    #write-Host -ForegroundColor Green "Restoring Backup $BackupFile to $Databasename"
    #Restore-SQLBackupFile -BackupFile $BackupFile -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $Databasename -ErrorAction Stop

    write-Host -ForegroundColor Green "Creating ServerInstance $ServerInstance"
    $Object = New-NAVServerInstance `
            -ServerInstance $ServerInstance `
            -DatabaseServer $DatabaseServer `
            -DatabaseInstance $DatabaseInstance `
            -ManagementServicesPort 7045 `
            -ClientServicesPort 7046 `
            -DatabaseName $Databasename          
         
    $null = Set-NAVServerInstance -Start -ServerInstance $ServerInstance
            
    if ($EnablePortSharing) {
        Enable-NAVServerInstancePortSharing -ServerInstance $ServerInstance
    }
    
    if ($StartWindowsClient) {
        Start-NAVWindowsClient `
            -Port $ServerInstanceObject.ClientServicesPort `
            -ServerInstance $ServerInstanceObject.ServerInstance `
            -ServerName ([net.dns]::gethostname())
    }

    if ($EnableJobQueue){
        write-host 'Job Queue created'
    }

    $Object 
}

