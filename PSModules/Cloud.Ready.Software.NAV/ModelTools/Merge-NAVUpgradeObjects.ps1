function Merge-NAVUpgradeObjects
{
    [CmdLetBinding()]
    param(
        [String] $OriginalObjects,
        [String] $ModifiedObjects,
        [String] $TargetObjects,
        [String] $WorkingFolder,
        [Switch] $Force,
        [Switch] $CreateDeltas,
        [String[]] $VersionListPrefixes,
        [switch] $DoNotOpenMergeResultFolder

    )

    $MergeResultFolder = Join-Path $WorkingFolder 'MergeResult'
    if(Test-Path $MergeResultFolder){
        if(!$force){
            if (!(Confirm-YesOrNo -title "Remove $MergeResultFolder ?" -message "Do you want to remove the existing folder $MergeResultFolder ?")){
                Write-Error "Merge cancelled!`n Folder $MergeResultFolder already exists."
                break
            }
        }
        $null = Remove-Item $MergeResultFolder -Recurse -Force
    }
    $null = New-Item -Path $MergeResultFolder -ItemType directory -Force

    #Create Delta's
    if($CreateDeltas){
        $Deltafolder1 = join-path $MergeResultFolder 'Deltas_ORIGINAL_MODIFIED'
        $Deltafolder2 = join-path $MergeResultFolder 'Deltas_ORIGINAL_TARGET'

        Write-Host "Creating Delta's to $Deltafolder1" -ForegroundColor Green
        $null = New-Item -Path $Deltafolder1 -ItemType directory -Force
        $DeltaOriginalModified = Compare-NAVApplicationObject `            -OriginalPath $OriginalObjects `
            -ModifiedPath $ModifiedObjects `
            -DeltaPath $Deltafolder1 `
            -NoCodeCompression `
            -Force `
            -PassThru
            
        Write-Host "Creating Delta's to $Deltafolder2" -ForegroundColor Green
        $null = New-Item -Path $Deltafolder2 -ItemType directory -Force
        $DeltaOriginalTarget = Compare-NAVApplicationObject `            -OriginalPath $OriginalObjects `
            -ModifiedPath $TargetObjects `
            -DeltaPath $Deltafolder2 `
            -NoCodeCompression `
            -Force `
            -PassThru       
    }

    #Merge objects
    Write-Host "Merge to $MergeResultFolder" -ForegroundColor Green
    $Mergeresult = Merge-NAVApplicationObject `
        -OriginalPath $OriginalObjects `
        -ModifiedPath $ModifiedObjects `
        -TargetPath $TargetObjects `
        -ResultPath $MergeResultFolder `
        -DateTimeProperty FromModified `
        -ModifiedProperty FromModified `
        -VersionListProperty FromModified `
        -DocumentationConflict TargetFirst `
        -Force
    
    #Update Versionlist
    Write-Host 'Update Versionlist and DateTime' -ForegroundColor Green
    $Mergeresult |
        Where-Object {$_.MergeResult –eq 'Merged' -or $_.MergeResult –eq 'Conflict'}  |  
            Merge-NAVApplicationObjectProperty -UpdateDateTime $true -UpdateVersionList $true -VersionListPrefixes $VersionListPrefixes
    
    $null = $mergeresult | Export-Clixml -Path (Join-Path $WorkingFolder 'MergeResult.xml')
    $MergeResultXML = get-item (Join-Path $WorkingFolder 'MergeResult.xml')

    if (!$DoNotOpenMergeResultFolder){
        Start-Process $MergeResultFolder
    }
        
    $MergeEndResult = @{MergeResult=$Mergeresult;Mergeresultfolder=$MergeResultFolder;DeltaOriginalVersusModified=$DeltaOriginalModified;DeltaOriginalVersusTarget=$DeltaOriginalTarget;MergeResultXML=$MergeResultXML}
    $MergeEndResult
}
    
