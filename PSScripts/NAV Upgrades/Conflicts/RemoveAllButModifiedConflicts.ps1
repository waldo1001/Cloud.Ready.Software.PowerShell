$InterestingFiles = Get-ChildItem (join-path $MergeResult.Mergeresultfolder ConflictModified)

#ConflictFiles
$ConflictFiles = Get-ChildItem (join-path $MergeResult.Mergeresultfolder '*.CONFLICT')
foreach ($ConflictFile in $ConflictFiles){
    if (-not($InterestingFiles.BaseName.Contains($ConflictFile.BaseName))){
        Write-Host "Deleted conflictfile $($ConflictFile.Name)"
        Remove-Item $ConflictFile.FullName
    }
}

#OriginalFiles
$OriginalFiles = Get-ChildItem (join-path $MergeResult.Mergeresultfolder 'ConflictOriginal')
foreach ($OriginalFile in $OriginalFiles){
    if (-not($InterestingFiles.BaseName.Contains($OriginalFile.BaseName))){
        Write-Host "Deleted Original File $($OriginalFile.Name)"
        Remove-Item $OriginalFile.FullName
    }
}

#TargetFiles
$TargetFiles = Get-ChildItem (join-path $MergeResult.Mergeresultfolder 'ConflictTarget')
foreach ($TargetFile in $TargetFiles){
    if (-not($InterestingFiles.BaseName.Contains($TargetFile.BaseName))){
        Write-Host "Deleted Target File $($TargetFile.Name)"
        Remove-Item $TargetFile.FullName
    }
}

#ResultFiles
<#
$ResultFiles = Get-ChildItem $MergeResult.Mergeresultfolder
foreach ($ResultFile in $ResultFiles){
    if (-not($InterestingFiles.BaseName.Contains($ResultFile.BaseName))){
        Write-Host "Deleted Result File $($ResultFile.Name)"
        Remove-Item $ResultFile.FullName
    }
}
#>
