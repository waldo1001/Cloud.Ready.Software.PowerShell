<#
STEP 5
Create Deltas in New Syntax
#>

$ContainerName = 'tempdev'
$OriginalPath = 'C:\ProgramData\NavContainerHelper\Migration\ORIGINAL_NEW' 
$ModifiedPath = 'C:\ProgramData\NavContainerHelper\Migration\MODIFIED_NEW' 
$DeltaPath = 'C:\ProgramData\NavContainerHelper\Migration\DELTA_NEW' 

$Session = Get-NavContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $OriginalPath, $ModifiedPath, $DeltaPath
    )

    $null = Remove-Item -Path $DeltaPath -Recurse -Force -ErrorAction SilentlyContinue
    $null = New-Item -Path $DeltaPath -ItemType Directory 

    Write-Host "Create delta in new syntax"
    $CompareResult = 
        Compare-NAVApplicationObject `
            -OriginalPath $OriginalPath `
            -ModifiedPath $ModifiedPath `
            -DeltaPath $DeltaPath `
            -ExportToNewSyntax 

} -ArgumentList $OriginalPath, $ModifiedPath, $DeltaPath