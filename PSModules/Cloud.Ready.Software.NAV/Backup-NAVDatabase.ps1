function Backup-NAVDatabase
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyname=$true)]
        [System.String]
        $ServerInstance,
        
        [Parameter(Mandatory=$false)]
        [int] 
        $TimeOut=0
    )
    begin {
        $null = Import-Module 'sqlps' -DisableNameChecking -ErrorAction Stop
    }
    
    Process {
        $ServerInstanceObject = Get-NAVServerInstance3 -ServerInstance $ServerInstance -ErrorAction Stop    
        if ([string]::isnullorempty($ServerInstanceObject.DatabaseInstance)){
            $DatabaseInstance = 'MSSQLSERVER'
        } else {
            $DatabaseInstance  = $ServerInstanceObject.DatabaseInstance
        }
        
        try{
            $BaseReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $ServerInstanceObject.DatabaseServer)
            $RegKey  = $BaseReg.OpenSubKey('SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL')
            $SQLinstancename = $RegKey.GetValue($DatabaseInstance)
            $RegKey  = $BaseReg.OpenSubKey("SOFTWARE\\Microsoft\\Microsoft SQL Server\\$SQLInstancename\\MSSQLServer")
            $Backuplocation = $RegKey.GetValue('BackupDirectory')
        } catch {
            #Try Local (probably Docker)
            $SQLInstanceName = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$DatabaseInstance 
            $Backuplocation = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$SQLInstanceName\MSSQLSERVER").BackupDirectory
        }

        $BackupFile = "$ServerInstance.bak"
        $BackupFileFullPath = Join-Path $Backuplocation $BackupFile
    
        $SQLString = "BACKUP DATABASE [$($ServerInstanceObject.Databasename)] TO  DISK = N'$BackupFileFullPath' WITH  COPY_ONLY, NOFORMAT, INIT,  NAME = N'NAVAPP_QA_MT-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10"
    
        write-Host -ForegroundColor Green "Backup up database $Database with this statement:"
        write-host -ForegroundColor Gray -Object $SQLString
        
        if ($ServerInstanceObject.DatabaseInstance) {
            Invoke-Sqlcmd -ServerInstance "$($ServerInstanceObject.DatabaseServer)\$($ServerInstanceObject.DatabaseInstance)" -Database 'master' -Query $SQLString -QueryTimeout $TimeOut
        } else {
            Invoke-Sqlcmd -ServerInstance "$($ServerInstanceObject.DatabaseServer)" -Database 'master' -Query $SQLString -QueryTimeout $TimeOut
        }
        
   
        Get-Item $BackupFileFullPath
    }
    
}

