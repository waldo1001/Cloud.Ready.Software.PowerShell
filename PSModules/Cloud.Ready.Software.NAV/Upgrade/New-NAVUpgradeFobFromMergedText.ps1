function New-NAVUpgradeFobFromMergedText
{
    [CmdLetBinding()]
    param(
        
        [String] $TargetServerInstance,
        [String] $LicenseFile,
        [String] $TextFileFolder,
        [String] $WorkingFolder,
        [String] $FobFileForCreatingUnlicensedObjects,
        [String] $ResultFobFile

    )

    
    $TargetServerInstanceObject = Get-NAVServerInstance4 -ServerInstance $TargetServerInstance -ErrorAction Stop
    $WorkingServerInstance = "$($TargetServerInstance)_Sandbox"

    #Creating Workspace
    $LogFolder = Join-Path $WorkingFolder 'Log_NAVUpgradeFobFromMergedText'
    if(Test-Path $LogFolder){Remove-Item $LogFolder -Force -Recurse}
    $LogImportFob        = join-path $LogFolder '01_ImportFob'
    $LogImportText       = join-path $LogFolder '02_ImportText'
    $LogCompileObjects   = join-path $LogFolder '03_CompileObjects'
    $LogResultObjectFile = join-path $LogFolder '04_ExportFob'

    #Create WorkingDB
    Copy-NAVEnvironment -ServerInstance $TargetServerInstance -ToServerInstance $WorkingServerInstance
    
    #Make Admin user DB-Owner
    $CurrentUser = [environment]::UserDomainName + '\' + [Environment]::UserName
    Invoke-SQL -DatabaseServer $TargetServerInstanceObject.DatabaseServer -DatabaseInstance $TargetServerInstanceObject.DatabaseInstance -DatabaseName $WorkingServerInstance -SQLCommand "CREATE USER [$CurrentUser] FOR LOGIN [$CurrentUser]" -ErrorAction Continue
    Invoke-SQL -DatabaseServer $TargetServerInstanceObject.DatabaseServer -DatabaseInstance $TargetServerInstanceObject.DatabaseInstance -DatabaseName $WorkingServerInstance -SQLCommand "ALTER ROLE [db_owner] ADD MEMBER [$CurrentUser]" -ErrorAction Continue

    #Drop ReVision Triggers
    Invoke-SQL -DatabaseServer $TargetServerInstanceObject.DatabaseServer -DatabaseInstance $TargetServerInstanceObject.DatabaseInstance -DatabaseName $WorkingServerInstance -SQLCommand 'DISABLE TRIGGER [dbo].[REVISION_UPDATE] ON [dbo].[Object]' -ErrorAction Continue
    Invoke-SQL -DatabaseServer $TargetServerInstanceObject.DatabaseServer -DatabaseInstance $TargetServerInstanceObject.DatabaseInstance -DatabaseName $WorkingServerInstance -SQLCommand 'DISABLE TRIGGER [dbo].[REVISION_INSERT] ON [dbo].[Object]' -ErrorAction Continue
    Invoke-SQL -DatabaseServer $TargetServerInstanceObject.DatabaseServer -DatabaseInstance $TargetServerInstanceObject.DatabaseInstance -DatabaseName $WorkingServerInstance -SQLCommand 'DISABLE TRIGGER [dbo].[REVISION_DELETE] ON [dbo].[Object]' -ErrorAction Continue


    #Import NAV LIcense
    if (!([string]::IsNullOrEmpty($LicenseFile))){
        Write-Host "Import NAV license in $WorkingServerInstance" -ForegroundColor Green
        Get-NAVServerInstance -ServerInstance $WorkingServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile -Database NavDatabase -WarningAction SilentlyContinue -ErrorAction Stop
        Set-NAVServerInstance -Restart -ServerInstance $WorkingServerInstance -ErrorAction continue
    }
     
    if (!([string]::IsNullOrEmpty($TargetServerInstanceObject.DatabaseInstance))){
        $DatabaseServer = "$($TargetServerInstanceObject.DatabaseServer)\$($TargetServerInstanceObject.DatabaseInstance)"
    } else
    {
        $DatabaseServer = $TargetServerInstanceObject.DatabaseServer
    }

    #Import unlicensed objects  
    if ($FobFileForCreatingUnlicensedObjects) {
        Write-host 'Import Fob for Unlicensed objects' -ForegroundColor Green
            $null = 
                Import-NAVApplicationObject `
                    -DatabaseServer $DatabaseServer `                    
                    -DatabaseName $WorkingServerInstance `
                    -Path $FobFileForCreatingUnlicensedObjects `
                    -LogPath $LogImportFob `
                    -NavServerName ([net.dns]::GetHostName()) `                    
                    -NavServerInstance $WorkingServerInstance `
                    -confirm:$false `
                    -ErrorAction continue `                    -SynchronizeSchemaChanges No `                    -ImportAction Overwrite
    }
    
    #Import Objects
    Write-Host 'Import Merged Objects' -ForegroundColor Green
    $null = 
        Import-NAVApplicationObject `
            -DatabaseServer $DatabaseServer `
            -DatabaseName $WorkingServerInstance `
            -Path "$TextFileFolder\*.txt" `
            -LogPath $LogImportText `
            -NavServerName ([net.dns]::GetHostName()) `
            -NavServerInstance $WorkingServerInstance `
            -confirm:$false `
            -ErrorAction continue `
            -ImportAction Overwrite
       
    #Compile Objects
    Write-Host 'Compile Uncompiled' -ForegroundColor Green
    $null = Compile-NAVApplicationObject `
        -DatabaseServer $DatabaseServer `
        -DatabaseName $WorkingServerInstance `
        -LogPath $LogCompileObjects `
        -SynchronizeSchemaChanges Force `
        -Filter 'Compiled=0' `
        -Recompile `
        -NavServerName ([net.dns]::GetHostName()) `
        -NavServerInstance $WorkingServerInstance `
        -ErrorAction Continue   
    
    if ((Get-ChildItem $LogCompileObjects | where Name -eq 'naverrorlog.txt').Count > 0)
    {        
        if (!(Confirm-YesOrNo -Title "There are still uncompiled objects" -Message "There are still uncompiled objects `n Do you want to continue and create fob?")){
            Break    
        }
    } 

    #Export Result
    if (!($ResultFobFile)){
        $ResultFobFile = Join-Path $WorkingFolder 'result.fob'
    }
    Write-Host "Export $ResultFobFile" -ForegroundColor Green
    $null = Export-NAVApplicationObject `
        -DatabaseServer $DatabaseServer `
        -DatabaseName $WorkingServerInstance `
        -Path $ResultFobFile `
        -LogPath $LogResultObjectFile `
        -ExportTxtSkipUnlicensed `
        -Force `
        -ErrorAction        

    #Remove WorkingDB
    if (!(Confirm-YesOrNo -Title "Remove Temporary DB" -Message "Do you want to continue and create remove the temporary DB?")){
        return (get-item $ResultFobFile) 
        break   
    }
    Write-Host "Remove Temporary DB $WorkingServerInstance" -ForegroundColor Green
    Remove-NAVEnvironment -ServerInstance $WorkingServerInstance -Force

    return (get-item $ResultFobFile)
}

