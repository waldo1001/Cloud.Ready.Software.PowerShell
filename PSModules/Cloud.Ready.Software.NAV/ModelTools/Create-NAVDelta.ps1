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
        $Folders =                 Create-NAVDelta `                    -OriginalServerInstance $NavAppOriginalServerInstance `                    -ModifiedServerInstance $ServerInstance `                    -WorkingFolder $NavAppWorkingFolder `                    -CreateReverseDeltas
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
        [Switch] $CompleteReset
        )
        
    $WorkingFolder = join-path -Path $Workingfolder -ChildPath 'Create-NAVDelta'

    $orginalObjects = Join-Path -Path $WorkingFolder -ChildPath 'original.txt'
    $modifiedObjects = Join-Path -Path $WorkingFolder -ChildPath 'modified.txt'
    $modifiedObjectsPartial = Join-Path -Path $WorkingFolder -ChildPath 'modified_partial.txt'

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
    
    $ExportJobs = @()
         
    if (!(Test-Path -Path $orginalObjects))
    {
        Write-Host -Foregroundcolor Green 'Exporting ORIGINAL objects ...'
        Export-NAVApplicationObject -DatabaseServer "$($OriginalServerInstanceObject.DatabaseServer)\$($OriginalServerInstanceObject.DatabaseInstance)" -DatabaseName $OriginalServerInstanceObject.Databasename -Path $orginalObjects -ExportTxtSkipUnlicensed | Out-Null
        Split-NAVApplicationObjectFile -Source $orginalObjects -Destination $originalFolder -PreserveFormatting -Force 
        Write-Host -Foregroundcolor Green "ORIGINAL objects exported to $originalObjects"        
    } else {
        write-warning "$orginalObjects already exists.  ORIGINAL objects are NOT exported again!"
    }
    
    Write-Host -Foregroundcolor Green 'Exporting MODIFIED objects ...'
    if ($CompleteReset) {
        if (Test-Path -Path $modifiedObjects){Remove-Item $modifiedObjects -Force -Recurse}
        if (Test-Path -Path $modifiedObjectsPartial){Remove-Item $modifiedObjectsPartial -Force -Recurse}
        if (Test-Path -Path $modifiedFolder){Remove-Item $modifiedFolder -Force -Recurse}
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
        
    Write-Host -Foregroundcolor Green 'Comparing and creating Deltas...'
    Get-ChildItem -Path $AppFilesFolder -Include *.* -File -Recurse | Remove-Item
    $result = Compare-NAVApplicationObject -OriginalPath ($originalFolder.FullName + '\*.txt') -ModifiedPath ($modifiedFolder.FullName + '\*.txt') -DeltaPath $AppFilesFolder -NoCodeCompression -Force 
    Write-Host -Foregroundcolor Green "Deltas extracted to $AppFilesFolder"

    if ($CreateReverseDeltas){
        $ReverseAppFilesFolder = Join-Path -Path $WorkingFolder -ChildPath 'AppFiles_Reverse'
        $ReverseAppFilesFolder = New-Item -ItemType Directory -Force -Path $ReverseAppFilesFolder 

        Get-ChildItem -Path $ReverseAppFilesFolder -Include *.* -File -Recurse | Remove-Item
        $result = Compare-NAVApplicationObject -OriginalPath ($modifiedFolder.FullName + '\*.txt') -ModifiedPath ($originalFolder.FullName + '\*.txt') -DeltaPath $ReverseAppFilesFolder -NoCodeCompression -Force 
        Write-Host -Foregroundcolor Green "Reverse Deltas extracted to $ReverseAppFilesFolder"
    
        return $AppFilesFolder,$ReverseAppFilesFolder
    } 
    else {
        return $AppFilesFolder
    }

    
}
