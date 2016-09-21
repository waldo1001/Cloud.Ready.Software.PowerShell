<#
.Synopsis
   Applies a folder with Deltafiles to a Serverinstance
.DESCRIPTION
   Steps:
     -Export objects
.PREREQUISITES
   - Run on ServiceTier.  
   - NAVModeltools must be present!
.EXAMPLE
   
#>
Function Apply-NAVDelta {
    [CmdLetBinding()]
    param(
        [parameter(Mandatory=$true)]
        [Alias('Fullname')]
        [String] $DeltaPath,
        [Parameter(Mandatory=$true)]
        [Alias('ServerInstance')] 
        [String] $TargetServerInstance,
        [Parameter(Mandatory=$true)]        
        [String] $Workingfolder,
        [parameter(Mandatory=$true)]
        [String] $VersionList,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Force','No','Yes')]
        [String] $SynchronizeSchemaChanges='Yes',
        [Parameter(Mandatory=$false)]
        [ValidateSet('Add','Remove')]
        [String] $DeltaType='Add',
        [Parameter(Mandatory=$false)]
        [switch] $OpenWorkingfolder,
        [Parameter(Mandatory=$false)]
        [switch] $DoNotImportAndCompileResult=$false,
        [Parameter(Mandatory=$false)]
        [switch] $ForceModifiedPropertyFalse
    )
    begin{
        #Set Constants
        $WorkingFolder = join-path $Workingfolder 'ApplyDeltas'
        $ExportFolder = Join-Path $WorkingFolder 'TargetObjects'
        $ResultFolder = Join-Path $WorkingFolder 'ApplyResult'
        $ReverseFolder = join-path $WorkingFolder 'ReverseDeltas'

        $TargetServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $TargetServerInstance

        #Set up workingfolder
        if (!(test-path $WorkingFolder)){
            $null = new-item -Path $WorkingFolder -ItemType directory -Force -ErrorAction Stop
        }

        $null = Remove-Item -Path $ExportFolder -Force -Recurse -ErrorAction Ignore
        $null = Remove-Item -Path $ResultFolder -Force -Recurse -ErrorAction Ignore
        $null = remove-item -Path $ReverseFolder -Force -Recurse -ErrorAction Ignore
        $null = new-item -Path $ExportFolder -ItemType directory -Force -ErrorAction stop
        $null = new-item -Path $ResultFolder -ItemType directory -Force -ErrorAction stop
        $null = New-Item -Path $ReverseFolder -ItemType directory -Force -ErrorAction stop
    }
    process{ 
        $NAVObjects = get-ChildItem $DeltaPath | Get-NAVApplicationObjectPropertyFromDelta -ErrorAction Stop
             
        Write-Host "Export objects to $ExportFolder" -ForegroundColor Green 
        foreach ($NAVObject in $NAVObjects){
            $ExportFile =
                Export-NAVApplicationObject2 `                    -ServerInstance $TargetServerInstanceObject.ServerInstance `                    -Path (Join-Path $ExportFolder "$((get-item $NAVObject.FileName).BaseName).txt") `                    -LogPath (Join-Path $ExportFolder 'Log') `                    -Filter "type=$($NAVObject.ObjectType);Id=$($NAVObject.Id)"     
                Write-Host "  $($ExportFile.Name) exported." -ForegroundColor Gray
            if ($ExportFile.Length -eq 0) {
                $null = $ExportFile | Remove-Item -Force
            }        
        }

        Write-Host 'Applying deltas' -ForegroundColor Green    
        if ($DeltaType -eq 'Add'){
            $ModifiedProperty = 'Yes'   
        }
        else {
            $ModifiedProperty = 'FromModified'
        }    
        if ($ForceModifiedPropertyFalse){
            $ModifiedProperty = 'No'
        } 
        $UpdateResult =             Update-NAVApplicationObject `                -TargetPath $ExportFolder `                -DeltaPath $DeltaPath `                -ResultPath $ResultFolder `
                -DateTimeProperty FromModified `                -ModifiedProperty $ModifiedProperty `                -VersionListProperty FromTarget `
                -ErrorAction Stop `                -Force

        Write-Host 'Updating versionlist' -ForegroundColor Green 
        $UpdateResult |
                Where-Object {$_.UpdateResult –eq 'Updated' -or $_.UpdateResult –eq 'Conflict' -or $_.MergeResult –eq 'Conflict'}  |  
                    Foreach {
                        $CurrObject = Get-NAVApplicationObjectProperty -Source $_.Result
                        If ($DeltaType -eq 'Add'){
                            $null = $CurrObject | Set-NAVApplicationObjectProperty -VersionListProperty (Add-NAVVersionListMember -VersionList $CurrObject.VersionList -AddVersionList $VersionList)         
                        }
                        else {
                            $null = $CurrObject | Set-NAVApplicationObjectProperty -VersionListProperty (Remove-NAVVersionListMember -VersionList $CurrObject.VersionList -RemoveVersionList $VersionList)                
                        }
                    }            
        $UpdateResult |
                Where-Object {$_.UpdateResult –eq 'Inserted'}  |  
                    Foreach {
                        $CurrObject = Get-NAVApplicationObjectProperty -Source $_.Result
                        $null = $CurrObject | Set-NAVApplicationObjectProperty -VersionListProperty $VersionList
                    }

        #Create reversedeltas
        Write-Host "Creating reverse deltas to $ReverseFolder" -ForegroundColor Green         
        $null =            Compare-NAVApplicationObject `                -OriginalPath (join-path $ResultFolder '*.txt')`                -ModifiedPath (join-path $ExportFolder '*.txt') `                -DeltaPath $ReverseFolder `                -Force

        if(!($DoNotImportAndCompileResult)){
            #Import 
            Write-Host "Importing result from $ResultFolder" -ForegroundColor Green         
            $null = 
                Get-ChildItem $ResultFolder -File -Filter '*.txt' |
                    Import-NAVApplicationObject2 `
                        -ServerInstance $TargetServerInstanceObject.ServerInstance `                        -LogPath (Join-Path $ResultFolder 'Log') `
                        -ImportAction Overwrite `                        -SynchronizeSchemaChanges $SynchronizeSchemaChanges `
                        -Confirm:$false  
    
            #Delete objects
            Write-Host "Deleting objects to $ExportFolder" -ForegroundColor Green 
            $UpdateResult |
                    Where-Object {$_.UpdateResult –eq 'Deleted'}  |  
                            Foreach {    
                                $null =
                                    Delete-NAVApplicationObject2 `                                        -ServerInstance $TargetServerInstanceObject.ServerInstance `                                        -LogPath (Join-Path $ResultFolder 'Log') `                                        -Filter "type=$($_.ObjectType);Id=$($_.Id)" `                                        -SynchronizeSchemaChanges $SynchronizeSchemaChanges `                                        -Confirm:$false 
                                Write-Host "  $($_.ObjectType) $($_.Id) deleted." -ForegroundColor Gray                            }

            Write-Host 'Compiling uncompiled' -ForegroundColor Green         
            $null =
                Compile-NAVApplicationObject2 `
                    -ServerInstance $TargetServerInstanceObject.ServerInstance `                    -LogPath (Join-Path $ResultFolder 'Log') `
                    -Filter 'Compiled=0' `                    -Recompile `                    -SynchronizeSchemaChanges $SynchronizeSchemaChanges 
        }
    }
    end{     
        $Conflicts = $UpdateResult | where UpdateResult -eq 'Conflicted'
        if (($Conflicts.Count) -gt 0) {
            write-warning -Message 'There were conflicts!  Please review:' 
            #foreach ($Conflict in $Conflicts){
                Write-Warning -Message "$Conflicts"
            #}
        }
       
        if($OpenWorkingfolder){Start-Process $Workingfolder}
        Write-Host 'Apply-NAVDelta done!' -ForegroundColor Green
    }
}