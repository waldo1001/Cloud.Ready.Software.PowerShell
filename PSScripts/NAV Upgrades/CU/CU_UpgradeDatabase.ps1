. (join-path $PSScriptRoot 'Set-UpgradeSettings.ps1')

#Install the CU
$IsoFile = 
    New-NAVCumulativeUpdateISOFile `
        -CumulativeUpdateFullPath $CUDownloadFile `
        -IsoDirectory $IsoDirectory

Get-NAVCumulativeUpdateDownloadVersionInfo -SourcePath $CUDownloadFile

Repair-NAV -DVDFolder $DVDFolder

#TODO: Load NA Cmdlets?

#Reset Workingfolder
if (test-path $WorkingFolder){
    if (Confirm-YesOrNo -title 'Remove WorkingFolder?' -message "Do you want to remove the WorkingFolder $WorkingFolder ?"){
        Remove-Item -Path $WorkingFolder -Force -Recurse
    } else {
        write-error '$WorkingFolder already exists.  Overwrite not allowed.'
        break
    }
}

#Get CU Objects
$ModifiedObjects =     Unzip-NAVCumulativeUpdateChangedObjects `        -SourcePath $CUDownloadFile `        -DestinationPath $WorkingFolder `        -Type txt$ModifiedObjectsFob =     Unzip-NAVCumulativeUpdateChangedObjects `        -SourcePath $CUDownloadFile `        -DestinationPath $WorkingFolder `        -Type fob#Export Target$TargetObjects =    Export-NAVCumulativeUpdateApplicationObjects `        -CUObjectFile $ModifiedObjects `        -ServerInstance $TargetServerInstance `        -Workingfolder $WorkingFolder#Export Original$OriginalObjects =    Export-NAVCumulativeUpdateApplicationObjects `        -CUObjectFile $ModifiedObjects `        -ServerInstance $OriginalServerInstance `        -Workingfolder $WorkingFolder#Merge
$MergeResult = Merge-NAVUpgradeObjects `
    -OriginalObjects $OriginalObjects `    -ModifiedObjects $ModifiedObjects `
    -TargetObjects $TargetObjects `
    -WorkingFolder $WorkingFolder `
    -CreateDeltas `
    -VersionListPrefixes $VersionListPrefixes `
    -Force

$NumberOfConflicts = ($MergeResult.Mergeresult | Where-Object {$_.MergeResult –eq 'Conflict'}).Count
if ($NumberOfConflicts -ge 1){
    if (!(Confirm-YesOrNo -Title "There are $NumberOfConflicts conflicts" -Message "There are $NumberOfConflicts conflicts `n Do you want to continue?")){
        Break    
    }
}

$NumberOfFails = ($MergeResult.Mergeresult | Where-Object {$_.MergeResult –eq 'Failed'}).Count
if ($NumberOfFails -ge 1){
    if (!(Confirm-YesOrNo -Title "There are $NumberOfFails failed objects" -Message "There are $NumberOfFails failed objects `n Do you want to continue?")){
        Break    
    } 
    write-host 'Failed objects:' -foregroundcolor Green

    Foreach($item in ($MergeResult.Mergeresult | Where-Object {$_.MergeResult –eq 'Failed'})){
        Write-Host "  $($Item.ObjectType) - $($Item.Id): $($Item.ErrorMessage)" -ForeGroundColor Gray
    }
}

#Building the Fob
$ResultFobFile = 
    New-NAVUpgradeFobFromMergedText `
        -TargetServerInstance $TargetServerInstance `
        -LicenseFile $NAVLicense `
        -TextFileFolder $MergeResult.Mergeresultfolder `
        -WorkingFolder $WorkingFolder `
        -FobFileForCreatingUnlicensedObjects $ModifiedObjectsFob `
        -ResultFobFile $ResultFobFile `
        -ErrorAction Stop


#Backup TargetDB
$TargetBackupLocation =
    Backup-NAVDatabase `
        -ServerInstance $TargetServerInstance 

#Upgrade Database
$UpgradedServerInstance = 
    Start-NAVUpgradeDatabase `
        -DatabaseBackupFile $TargetBackupLocation `
        -WorkingFolder $WorkingFolder `
        -LicenseFile $NAVLicense `
        -ResultObjectFile $ResultFobFile `
        -SyncMode ForceSync