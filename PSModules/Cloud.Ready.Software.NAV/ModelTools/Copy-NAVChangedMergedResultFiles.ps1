function Copy-NAVChangedMergedResultFiles
{
    [CmdletBinding()]
    Param(
        $MergeResultObjects,
        $DestinationFolder
    )
    $Errors = @()
    $ObjectsToCopy = $MergeResultObjects | where-Object {($_.MergeResult -ine 'Unchanged') -and ($_.MergeResult -ine 'Failed')}
    $ObjectsToCopy = $ObjectsToCopy | where-Object {($_.MergeResult.Value -ine 'Unchanged') -and ($_.MergeResult.Value -ine 'Failed')}

    if(!($ObjectsToCopy.Count -ge 1)){
        Write-Warning 'No merged Objects! Possibly identical object sets'
        break
    }

    if(!$DestinationFolder){
        $tempItem = Get-item $ObjectsToCopy[0].Result.FileName        
        $DestinationFolder = join-path $tempItem.Directory.Parent.FullName "$($tempItem.directory.Name)_ChangedOnly"
    }
    if(Test-Path $DestinationFolder) {Remove-Item -Path $DestinationFolder -Recurse -Force}     New-Item -Path $DestinationFolder -ItemType directory | Out-Null
    
    forEach ($ObjectToCopy in $ObjectsToCopy) {        
        try {
            $ItemToCopy = $null
            if (![String]::IsNullOrEmpty($ObjectToCopy.Result.FileName)){
                $ItemToCopy = Get-Item $ObjectToCopy.Result.FileName
                Copy-Item $ItemToCopy -Destination $DestinationFolder -ErrorAction SilentlyContinue
                Write-Verbose "Copying $ItemToCopy to $DestinationFolder"
            }
        }
        catch {
            $Errors += "Error Copying $($ObjectToCopy.ObjectType) $($ObjectToCopy.Id) ($_)"
        } 
    }

    if ($Errors.Count -gt 0) {
        Write-Host "ATTENTION: Errors in function 'Copy-NAVChangedMergedResultFiles' when copying files to $DestinationFolder" -ForegroundColor Red
        foreach ($Error in $Errors){
            Write-Error $Error
        }
    }

    return $DestinationFolder
}
