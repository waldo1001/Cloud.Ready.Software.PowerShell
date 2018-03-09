<#
STEP 3
Apply Delta to database & export as new syntax
#>

$ContainerName = 'tempdev'
$DeltaPath = 'C:\ProgramData\NavContainerHelper\Migration\DELTA'
$OriginalPath = 'c:\ProgramData\NavContainerHelper\Migration\ORIGINAL'
$WorkingPath = 'c:\ProgramData\NavContainerHelper\Migration\ApplyDelta' 
$AppliedDeltaPath = 'c:\ProgramData\NavContainerHelper\Migration\AppliedDelta' 

$Session = Get-NavContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $DeltaPath, $OriginalPath, $WorkingPath, $AppliedDeltaPath
    )
    
    Write-Host "Reset Paths"
    $null = Remove-Item -Path $WorkingPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = New-Item -Path $WorkingPath -ItemType Directory 
    $null = Remove-Item -Path $AppliedDeltaPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = New-Item -Path $AppliedDeltaPath -ItemType Directory 
        
    Write-Host "Copy corresponding original files to working-directory"
    Get-ChildItem -Path $DeltaPath | % {
        Get-ChildItem $OriginalPath | where BaseName -eq $_.BaseName | Copy-Item -Destination $WorkingPath         
    }
    
    Write-Host "Apply Deltas"
    $UpdateResult = 
    Update-NAVApplicationObject `
        -DeltaPath $DeltaPath `
        -TargetPath $WorkingPath `
        -ResultPath $AppliedDeltaPath `
        -Force
    
    Write-Host "Import Deltas    "
    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstance NAV -AsXml).configuration.appSettings.add | Where Key -eq DatabaseName).value    
    Import-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -Path "$AppliedDeltaPath\*.txt" `
        -LogPath "$WorkingPath\ImportLog" `
        -ImportAction Overwrite `
        -SynchronizeSchemaChanges Force `
        -Confirm:$false

    Write-Host "Compile Uncompiled"
    Compile-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -LogPath "$WorkingPath\CompileLog" `
        -Recompile `
        -Filter "Compiled=0"

} -ArgumentList $DeltaPath, $OriginalPath, $WorkingPath, $AppliedDeltaPath