function Create-NAVDelta
{    <#
    .Synopsis
       Create delta's, specifically meant to do NAVApps, which means: including permissionsets
    .DESCRIPTION
       
    .NOTES
       It creates deltas in the 'Appfiles' folder       
    .PREREQUISITES
       <TODO: like positioning the prompt and such>
    .EXAMPLE
        $Folders = 
                Create-NAVDelta `
                    -OriginalServerInstance $NavAppOriginalServerInstance `
                    -ModifiedServerInstance $ServerInstance `
                    -WorkingFolder $NavAppWorkingFolder `
                    -CreateReverseDeltas
    #>

    [CmdLetBinding()]
    param(
        [parameter(mandatory=$true)]
        [string] $OriginalServerInstance,
        [parameter(mandatory=$true)]
        [string] $ModifiedServerInstance,
        [parameter(mandatory=$true)]
        [string] $WorkingFolder,
        [parameter(mandatory=$false)]
        [switch] $CreateReverseDeltas,
        [parameter(Mandatory=$false)]
        [Switch] $CompleteReset,
        [parameter(Mandatory=$False)]
        [switch] $IncludeFilesInNewSyntax
        )
        
    $WorkingFolder = join-path -Path $Workingfolder -ChildPath 'Create-NAVDelta'

    $orginalObjects = Join-Path -Path $WorkingFolder -ChildPath 'Original.txt'
    $modifiedObjects = Join-Path -Path $WorkingFolder -ChildPath 'Modified.txt'
    $modifiedObjectsPartial = Join-Path -Path $WorkingFolder -ChildPath 'Modified_partial.txt'

    $OriginalServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $OriginalServerInstance
    $ModifiedServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ModifiedServerInstance

    $AppFilesFolder = Join-Path -Path $WorkingFolder -ChildPath 'AppFiles'
    $AppFilesFolder = New-Item -ItemType Directory -Force -Path $AppFilesFolder 

    $ReverseAppFilesFolder = Join-Path -Path $WorkingFolder -ChildPath 'AppFiles_Reverse'
    $ReverseAppFilesFolder = New-Item -ItemType Directory -Force -Path $ReverseAppFilesFolder 

    $originalFolder = Join-Path -Path $WorkingFolder -ChildPath 'Original'
    $originalFolder = New-Item -ItemType Directory -Force -Path $originalFolder 

    $modifiedFolder = Join-Path -Path $WorkingFolder -ChildPath 'Modified'
    $modifiedFolder = New-Item -ItemType Directory -Force -Path $modifiedFolder
    
    $originalObjectsNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'Original_NewSyntax.txt'
    $modifiedObjectsNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'Modified_NewSyntax.txt'
    $modifiedObjectsPartialNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'Modified_partial_NewSyntax.txt'
    $originalFolderNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'Original_NewSyntax'
    $originalFolderNewSyntax = New-Item -ItemType Directory -Force -Path $originalFolderNewSyntax
    $modifiedFolderNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'Modified_NewSyntax'
    $modifiedFolderNewSyntax = New-Item -ItemType Directory -Force -Path $modifiedFolderNewSyntax
    $AppFilesFolderNewSyntax = Join-Path -Path $WorkingFolder -ChildPath 'AppFiles_NewSyntax'
    $AppFilesFolderNewSyntax = New-Item -ItemType Directory -Force -Path $AppFilesFolderNewSyntax

    if (!(Test-Path -Path $orginalObjects))
    {
        Write-Host -Foregroundcolor Green 'Exporting ORIGINAL objects ...'
        Export-NAVApplicationObject -DatabaseServer "$($OriginalServerInstanceObject.DatabaseServer)\$($OriginalServerInstanceObject.DatabaseInstance)" -DatabaseName $OriginalServerInstanceObject.Databasename -Path $orginalObjects -ExportTxtSkipUnlicensed | Out-Null
        Split-NAVApplicationObjectFile -Source $orginalObjects -Destination $originalFolder -PreserveFormatting -Force 
        Write-Host -Foregroundcolor Green "ORIGINAL objects exported to $originalObjects"        
    } else {
        write-warning "$orginalObjects already exists.  ORIGINAL objects are NOT exported again!"
    }
    
    if ($IncludeFilesInNewSyntax -and !(Test-Path -Path $originalObjectsNewSyntax))    
    {
        Write-Host -Foregroundcolor Green 'Exporting ORIGINAL objects (NewSyntax)...'
        Export-NAVApplicationObject -DatabaseServer "$($OriginalServerInstanceObject.DatabaseServer)\$($OriginalServerInstanceObject.DatabaseInstance)" -DatabaseName $OriginalServerInstanceObject.Databasename -Path $originalObjectsNewSyntax -ExportTxtSkipUnlicensed -ExportToNewSyntax | Out-Null
        Split-NAVApplicationObjectFile -Source $originalObjectsNewSyntax -Destination $originalFolderNewSyntax -PreserveFormatting -Force 
        Write-Host -Foregroundcolor Green "ORIGINAL objects exported to $IncludeFilesInNewSyntax (NewSyntax)"        
    } else {
        write-warning "$IncludeFilesInNewSyntax already exists.  ORIGINAL objects are NOT exported again! (NewSyntax)"
    }

    Write-Host -Foregroundcolor Green 'Exporting MODIFIED objects ...'
    if ($CompleteReset) {
        if (Test-Path -Path $modifiedObjects){Remove-Item $modifiedObjects -Force -Recurse}
        if (Test-Path -Path $modifiedObjectsPartial){Remove-Item $modifiedObjectsPartial -Force -Recurse}
        if (Test-Path -Path $modifiedFolder){Remove-Item $modifiedFolder -Force -Recurse}

        if (Test-Path -Path $modifiedObjectsNewSyntax){Remove-Item $modifiedObjectsNewSyntax -Force -Recurse}
        if (Test-Path -Path $modifiedObjectsPartialNewSyntax){Remove-Item $modifiedObjectsPartialNewSyntax -Force -Recurse}
        if (Test-Path -Path $modifiedFolderNewSyntax){Remove-Item $modifiedFolderNewSyntax -Force -Recurse}
    }
   
    if (!(Test-Path -Path $modifiedObjects))
    {
        Export-NAVApplicationObject -DatabaseServer "$($ModifiedServerInstanceObject.DatabaseServer)\$($ModifiedServerInstanceObject.DatabaseInstance)" -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjects -ExportTxtSkipUnlicensed | Out-Null   
        Split-NAVApplicationObjectFile -Source $modifiedObjects -Destination $modifiedFolder -PreserveFormatting -Force
        Write-Host -Foregroundcolor Green "All objects from $ModifiedServerInstance exported to $modifiedObjects"
    } else {
        Export-NAVApplicationObject -DatabaseServer "$($ModifiedServerInstanceObject.DatabaseServer)\$($ModifiedServerInstanceObject.DatabaseInstance)" -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjectsPartial -Filter 'Modified=1' -ExportTxtSkipUnlicensed -Force | Out-Null   
        
        if (!(Test-Path $modifiedObjectsPartial) -or ((get-item $modifiedObjectsPartial).Length -eq 0)){
            write-error 'No modified objects found! Nothing exported'
        } else {
            Split-NAVApplicationObjectFile -Source $modifiedObjectsPartial -Destination $modifiedFolder -PreserveFormatting -Force
            write-warning "$modifiedObjects already existed.  Only objects with MODIFIED=TRUE were exported!"
            Write-Host -Foregroundcolor Green "Modified objects from $ModifiedServerInstance exported to $modifiedObjects"
        }                
    }
     
    if ($IncludeFilesInNewSyntax -and !(Test-Path -Path $modifiedObjectsNewSyntax))    {
        Export-NAVApplicationObject -DatabaseServer "$($ModifiedServerInstanceObject.DatabaseServer)\$($ModifiedServerInstanceObject.DatabaseInstance)" -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjectsNewSyntax -ExportTxtSkipUnlicensed -ExportToNewSyntax | Out-Null   
        Split-NAVApplicationObjectFile -Source $modifiedObjectsNewSyntax -Destination $modifiedFolderNewSyntax -PreserveFormatting -Force
        Write-Host -Foregroundcolor Green "All objects from $ModifiedServerInstance exported to $modifiedObjectsNewSyntax (NewSyntax)"
    } else {
        Export-NAVApplicationObject -DatabaseServer "$($ModifiedServerInstanceObject.DatabaseServer)\$($ModifiedServerInstanceObject.DatabaseInstance)" -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjectsPartialNewSyntax -Filter 'Modified=1' -ExportTxtSkipUnlicensed -Force -ExportToNewSyntax | Out-Null   
        
        if (!(Test-Path $modifiedObjectsPartialNewSyntax) -or ((get-item $modifiedObjectsPartialNewSyntax).Length -eq 0)){
            write-error 'No modified objects found! Nothing exported (NewSyntax)'
        } else {
            Split-NAVApplicationObjectFile -Source $modifiedObjectsPartialNewSyntax -Destination $modifiedFolderNewSyntax -PreserveFormatting -Force
            write-warning "$modifiedObjectsNewSyntax already existed.  Only objects with MODIFIED=TRUE were exported! (NewSyntax)"
            Write-Host -Foregroundcolor Green "Modified objects from $ModifiedServerInstance exported to $modifiedObjectsNewSyntax (NewSyntax)"
        }                
    }

    Write-Host -Foregroundcolor Green 'Comparing and creating Deltas...'
    Get-ChildItem -Path $AppFilesFolder -Include *.* -File -Recurse | Remove-Item
    $result = Compare-NAVApplicationObject -OriginalPath ($originalFolder.FullName + '\*.txt') -ModifiedPath ($modifiedFolder.FullName + '\*.txt') -DeltaPath $AppFilesFolder -NoCodeCompression -Force 
    Write-Host -Foregroundcolor Green "Deltas extracted to $AppFilesFolder"

    if ($IncludeFilesInNewSyntax){
        Write-Host -Foregroundcolor Green 'Comparing and creating Deltas...(NewSyntax)'
        Get-ChildItem -Path $AppFilesFolderNewSyntax -Include *.* -File -Recurse | Remove-Item
        $result = Compare-NAVApplicationObject -OriginalPath ($originalFolderNewSyntax.FullName + '\*.txt') -ModifiedPath ($modifiedFolderNewSyntax.FullName + '\*.txt') -DeltaPath $AppFilesFolderNewSyntax -NoCodeCompression -Force 
        Write-Host -Foregroundcolor Green "Deltas extracted to $AppFilesFolderNewSyntax (NewSyntax)"
    }

    if ($CreateReverseDeltas){
        $ReverseAppFilesFolder = Join-Path -Path $WorkingFolder -ChildPath 'AppFiles_Reverse'
        $ReverseAppFilesFolder = New-Item -ItemType Directory -Force -Path $ReverseAppFilesFolder 

        Get-ChildItem -Path $ReverseAppFilesFolder -Include *.* -File -Recurse | Remove-Item
        $result = Compare-NAVApplicationObject -OriginalPath ($modifiedFolder.FullName + '\*.txt') -ModifiedPath ($originalFolder.FullName + '\*.txt') -DeltaPath $ReverseAppFilesFolder -NoCodeCompression -Force 
        Write-Host -Foregroundcolor Green "Reverse Deltas extracted to $ReverseAppFilesFolder"        
    } 
    
    $Folders = @()
    $Folders += $AppFilesFolder
    if ($CreateReverseDeltas){$Folders += $ReverseAppFilesFolder}
    if ($IncludeFilesInNewSyntax) {$Folders += $AppFilesFolderNewSyntax}

    return $Folders
}
