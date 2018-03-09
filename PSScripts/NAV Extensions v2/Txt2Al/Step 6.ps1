<#
STEP 6
Convert to New Syntax
#>

$ContainerName = 'tempdev'
$DeltaPath = 'C:\ProgramData\NavContainerHelper\Migration\DELTA_NEW' 
$AlPath = 'C:\ProgramData\NavContainerHelper\Migration\AL'
$ExtensionStartId = 50000

$Session = Get-NavContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $DeltaPath, $AlPath, $ExtensionStartId
    )

    Write-Host "Migrating to AL"
    $Arguments = @("--source=$DeltaPath", "--target=$AlPath", "--rename", "--extensionStartId $ExtensionStartId")
    
    Start-Process "$NavClientPath\txt2al.exe" -ArgumentList $Arguments

} -ArgumentList $DeltaPath, $AlPath, $ExtensionStartId
