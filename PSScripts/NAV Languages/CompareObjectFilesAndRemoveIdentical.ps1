
$CompareResult = 
Compare-NAVApplicationObject `
    -OriginalPath .\DistriDEV `
    -ModifiedPath .\DistriDEV_Translated `
    -DeltaPath .\Delta `
    -PassThru

$Items = @()
$CompareResult | where CompareResult -ne 'Identical' | % {
    $Items += get-item(join-path ".\DistriDEV_Translated" "$((get-item $_.PSPath).BaseName).txt")
}

$Items | Join-NAVApplicationObjectFile -Destination .\DistriDEV_Translated_Filtered.Txt

Split-NAVApplicationObjectFile `
-Source .\DistriDEV_Translated_Filtered.Txt `
-Destination .\DistriDEV_Translated_Filtered

$Items = Get-ChildItem .\DistriDEV_Translated_Filtered
$Items | Get-NAVApplicationObjectProperty | % {
    
    Set-NAVApplicationObjectProperty `
    -TargetPath $_.FileName `
    -VersionListProperty "$($_.versionList),M32436" `
    -ModifiedProperty Yes `
    -DateTimeProperty (get-date -Format g) 
    
}
$Items | Join-NAVApplicationObjectFile -Destination .\DistriDEV_Translated_Filtered.Txt