function Create-NAVAppFiles
{
    [CmdLetBinding()]
    param(
        [string] $OriginalServerInstance,
        [string] $ModifiedServerInstance,
        [string] $BuildPath,
        [String] $PermissionSetId='')

    $orginalObjects = Join-Path -Path $BuildPath -ChildPath 'original.txt'
    $modifiedObjects = Join-Path -Path $BuildPath -ChildPath 'modified.txt'
    $modifiedObjectsPartial = Join-Path -Path $BuildPath -ChildPath 'modified_partial.txt'

    $OriginalServerInstanceObject = Get-NAVServerInstance4 -ServerInstance $OriginalServerInstance
    $ModifiedServerInstanceObject = Get-NAVServerInstance4 -ServerInstance $ModifiedServerInstance

    $AppFilesFolder = Join-Path -Path $BuildPath -ChildPath 'AppFiles'
    $AppFilesFolder = New-Item -ItemType Directory -Force -Path $AppFilesFolder 

    $originalFolder = Join-Path -Path $BuildPath -ChildPath 'Original'
    $originalFolder = New-Item -ItemType Directory -Force -Path $originalFolder 

    $modifiedFolder = Join-Path -Path $BuildPath -ChildPath 'Modified'
    $modifiedFolder = New-Item -ItemType Directory -Force -Path $modifiedFolder
    
    $ExportJobs = @()
         
    if (!(Test-Path -Path $orginalObjects))
    {
        Write-Host -Foregroundcolor Green 'Exporting ORIGINAL objects ...'
        Export-NAVApplicationObject -DatabaseServer $OriginalServerInstanceObject.DatabaseServer -DatabaseName $OriginalServerInstanceObject.Databasename -Path $orginalObjects -ExportTxtSkipUnlicensed | Out-Null
        Split-NAVApplicationObjectFile -Source $orginalObjects -Destination $originalFolder -PreserveFormatting -Force 
        Write-Host -Foregroundcolor Green "ORIGINAL objects exported to $originalObjects"        
    } else {
        write-warning "$orginalObjects already exists.  ORIGINAL objects are NOT exported again!"
    }
    
    Write-Host -Foregroundcolor Green 'Exporting MODIFIED objects ...'
       
    if (!(Test-Path -Path $modifiedObjects))
    {
        Export-NAVApplicationObject -DatabaseServer $ModifiedServerInstanceObject.DatabaseServer -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjects -ExportTxtSkipUnlicensed | Out-Null   
        Split-NAVApplicationObjectFile -Source $modifiedObjects -Destination $modifiedFolder -PreserveFormatting -Force
        Write-Host -Foregroundcolor Green "All objects from $ModifiedServerInstance exported to $modifiedObjects"
    } else {
        Export-NAVApplicationObject -DatabaseServer $ModifiedServerInstanceObject.DatabaseServer -DatabaseName $ModifiedServerInstanceObject.DatabaseName -Path $modifiedObjectsPartial -Filter 'Modified=1' -ExportTxtSkipUnlicensed -Force | Out-Null   
        
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


    #Create Permission Sets
    if(!([String]::Isnullorempty($PermissionSetId))){
        Write-Host -Foregroundcolor Green "Exporting PermissionSet $PermissionSetId from $ModifiedServerInstance ..."
        try { 
            Export-NAVAppPermissionSet -ServerInstance $ModifiedServerInstance -PermissionSetId $PermissionSetId -Path (join-path $AppFilesFolder "$PermissionSetId.xml") -ErrorAction SilentlyContinue
        }
        Catch { 
            Write-Warning -Message "Permissionset $PermissionSetId was not found!" }
    }   

    return $AppFilesFolder
}
