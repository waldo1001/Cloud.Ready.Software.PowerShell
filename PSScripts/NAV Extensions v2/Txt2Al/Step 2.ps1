<#
STEP 2
Export Original objects (normal and new syntax)
#>

$ContainerName = 'tempdev'
$Filter = ''
$OriginalPath = 'C:\ProgramData\NavContainerHelper\Migration\ORIGINAL'
$OriginalNewSyntaxPath = 'C:\ProgramData\NavContainerHelper\Migration\ORIGINAL_NEW'

$Session = Get-NavContainerSession -containerName $ContainerName
Invoke-Command -Session $Session -ScriptBlock {
    param(
        $Filter, $OriginalPath, $OriginalNewSyntaxPath
    )

    $DatabaseName = ((Get-NAVServerConfiguration -ServerInstance NAV -AsXml).configuration.appSettings.add | Where Key -eq DatabaseName).value

    Write-Host "Export Objects to normal syntax"
    Export-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -Path "$OriginalPath.txt" `
        -LogPath "$OriginalPath.Log" `
        -ExportTxtSkipUnlicensed `
        -Filter $Filter
    
    Write-Host "Export Objects to new syntax"
    Export-NAVApplicationObject `
        -DatabaseName $DatabaseName `
        -Path "$OriginalNewSyntaxPath.txt" `
        -LogPath "$OriginalNewSyntaxPath.Log" `
        -ExportTxtSkipUnlicensed `
        -Filter $Filter `
        -ExportToNewSyntax

    Write-Host "Split the objects"
    Split-NAVApplicationObjectFile `
        -Source "$OriginalPath.txt" `
        -Destination $OriginalPath

    Split-NAVApplicationObjectFile `
        -Source "$OriginalNewSyntaxPath.txt" `
        -Destination $OriginalNewSyntaxPath

    Write-Host "Remove Full Files"
    Remove-Item -Path "$OriginalPath.txt"
    Remove-Item -Path "$OriginalNewSyntaxPath.txt" 

} -ArgumentList $Filter, $OriginalPath, $OriginalNewSyntaxPath