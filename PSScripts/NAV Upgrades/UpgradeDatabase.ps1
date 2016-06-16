. (join-path $PSScriptRoot 'Set-UpgradeSettings.ps1')

clear-host

$StartedDateTime = Get-Date

#Reset Workingfolder
if (test-path $WorkingFolder){
    if (Confirm-YesOrNo -title 'Remove WorkingFolder?' -message "Do you want to remove the WorkingFolder $WorkingFolder ?"){
        Remove-Item -Path $WorkingFolder -Force -Recurse
    } else {
        write-error '$WorkingFolder already exists.  Overwrite not allowed.'
        break
    }
}

$MergeResult = Merge-NAVUpgradeObjects `
    -OriginalObjects $OriginalObjects `    -ModifiedObjects $ModifiedObjects `
    -TargetObjects $TargetObjects `
    -WorkingFolder $WorkingFolder `
    -CreateDeltas `
    -VersionListPrefixes $VersionListPrefixes `
    -Force

$DeletedObjects = $MergeResult.DeltaOriginalVersusTarget | where CompareResult -eq 'Deleted'    

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
        Write-Host "  $($Item.ObjectType) - $($Item.Id): $($Item.Error)" -ForeGroundColor Gray
    }
}

if (!$MergeResult) {$MergeResult = Import-Clixml -Path "$WorkingFolder\MergeResult.xml"}

$FilteredMergeResultFolder = Copy-NAVChangedMergedResultFiles -MergeResultObjects $MergeResult.MergeResult

$FobFile = 
    New-NAVUpgradeFobFromMergedText `
        -TargetServerInstance $TargetServerInstance `
        -LicenseFile $NAVLicense `
        -TextFileFolder $FilteredMergeResultFolder `
        -WorkingFolder $WorkingFolder `
        -ErrorAction Stop `
        -ResultFobFile $ResultObjectFile `
        -Verbose


$UpgradedServerInstance = 
    Start-NAVUpgradeDatabase `
        -DatabaseBackupFile $ModifiedDatabaseBackupLocation `
        -WorkingFolder $WorkingFolder `
        -LicenseFile $NAVLicense `
        -UpgradeToolkit $UpgradeCodeunitsFullPath `
        -ResultObjectFile $FobFile `
        -DeletedObjects $DeletedObjects `
        -SyncMode Sync `
        -IfResultDBExists Overwrite
  
$StoppedDateTime = Get-Date
  
Write-Host ''
Write-Host ''    
Write-Host '****************************************************' -ForegroundColor Yellow
write-host 'Done!' -ForegroundColor Yellow
Write-host "$($UpgradedServerInstance.ServerInstance) created!" -ForegroundColor Yellow
Write-Host 'Total Duration' ([Math]::Round(($StoppedDateTime - $StartedDateTime).TotalSeconds)) 'seconds' -ForegroundColor Yellow
Write-Host '****************************************************' -ForegroundColor Yellow

