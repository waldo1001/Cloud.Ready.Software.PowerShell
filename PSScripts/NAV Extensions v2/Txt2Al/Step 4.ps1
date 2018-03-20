<#
STEP 4
Export Modified objects (normal and new syntax)
#>

$ContainerName = 'tempdev'
$ModifiedPath = 'C:\ProgramData\NavContainerHelper\Migration\MODIFIED'
$ModifiedNewSyntaxPath = 'C:\ProgramData\NavContainerHelper\Migration\MODIFIED_NEW'
$Filter = ''

$Session = Get-NavContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $Filter, $ModifiedPath, $ModifiedNewSyntaxPath
    )

    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstance NAV -AsXml).configuration.appSettings.add | Where Key -eq DatabaseName).value

<#     Write-Host "Export Objects to normal syntax"
    Export-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -Path "$ModifiedPath.txt" `
        -LogPath "$ModifiedPath.Log" `
        -ExportTxtSkipUnlicensed `
        -Filter $Filter #>
    
    Write-Host "Export Objects to new syntax"
    Export-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -Path "$ModifiedNewSyntaxPath.txt" `
        -LogPath "$ModifiedNewSyntaxPath.Log" `
        -ExportTxtSkipUnlicensed `
        -Filter $Filter `
        -ExportToNewSyntax

<#     Write-Host "Split the objects"
    Split-NAVApplicationObjectFile `
        -Source "$ModifiedPath.txt" `
        -Destination $ModifiedPath  #>

    Split-NAVApplicationObjectFile `
        -Source "$ModifiedNewSyntaxPath.txt" `
        -Destination $ModifiedNewSyntaxPath

    Write-Host "Remove Full Files"
    Remove-Item -Path "$ModifiedPath.txt"
    Remove-Item -Path "$ModifiedNewSyntaxPath.txt" 

} -ArgumentList $Filter, $ModifiedPath, $ModifiedNewSyntaxPath