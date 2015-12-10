function Backup-NAVApplicationObjects
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Object] $ServerInstance,
        [Parameter(Mandatory=$False)]
        [ValidateSet('AllObjects','OnlyModified','CustomFilter')]
        [String] $BackupOption,
        [Parameter(Mandatory=$False)]
        [String] $CustomFilter,
        [Parameter(Mandatory=$true)]
        [String] $BackupPath,
        [Parameter(Mandatory=$false)]
        [Object] $NavAppOriginalServerInstance,
        [Parameter(Mandatory=$false)]
        [String] $NavAppWorkingFolder,
        [Parameter(Mandatory=$false)]
        [Object] $ExportPermissionSetId
    )
    Process{
        $ServerInstanceObject = (Get-NAVServerInstance4 -ServerInstance $ServerInstance)
        
        switch($BackupOption){
            'AllObjects' {
                $ObjectFilter = ''
            }
            'OnlyModified' {
                $ObjectFilter = 'Modified=1'
            }
            'CustomFilter'{
                $ObjectFilter = $CustomFilter
            }
        }
        $BackupFiles = @()
        
        $Backupfiletxt = join-path $BackupPath "$($ServerInstance)_$($BackupOption).txt"
        $Backupfilefob = join-path $BackupPath "$($ServerInstance)_$($BackupOption).fob"
        
        if ([String]::IsNullOrEmpty($ObjectFilter)){
            Write-host -ForegroundColor Green "Creating $Backupfiletxt"
            Export-NAVApplicationObject -DatabaseServer $ServerInstanceObject.DatabaseServer -DatabaseName $ServerInstanceObject.DatabaseName -Path $Backupfiletxt -Force
            Write-host -ForegroundColor Green "Creating $Backupfilefob"
            Export-NAVApplicationObject -DatabaseServer $ServerInstanceObject.DatabaseServer -DatabaseName $ServerInstanceObject.DatabaseName -Path $Backupfilefob -Force        
        }
        Else {
            Write-host -ForegroundColor Green "Creating $Backupfiletxt"
            Export-NAVApplicationObject -Filter $ObjectFilter -DatabaseServer $ServerInstanceObject.DatabaseServer -DatabaseName $ServerInstanceObject.DatabaseName -Path $Backupfiletxt -Force
            Write-host -ForegroundColor Green "Creating $Backupfilefob"
            Export-NAVApplicationObject -Filter $ObjectFilter -DatabaseServer $ServerInstanceObject.DatabaseServer -DatabaseName $ServerInstanceObject.DatabaseName -Path $Backupfilefob -Force
        
        }
                
        if(!([String]::IsNullOrEmpty($OriginalServerInstance))) {
            if ([string]::IsNullOrEmpty(($NavAppWorkingFolder))){
                Write-Error 'Please provide a workingfolder if you want to create delta''s'
                break
            }

            $AppFilesFolder = Create-NAVAppFiles -OriginalServerInstance $OriginalServerInstance -ModifiedServerInstance $ServerInstance -BuildPath $NavAppWorkingFolder -PermissionSetId $ExportPermissionSetId
            $null = Copy-Item -Path $appFilesFolder -Destination $BackupPath -Recurse -Force
            get-childitem $BackupPath
        } else {
            write-warning 'No delta''s were created!'
        }
        
    }
    
}

