. (Join-path $PSScriptRoot '_SettingsCustomers.ps1')

$AppFiles = Get-ChildItem 'C:\Temp\apps'

function get-AppNameFromFileName($AppFile) {
    $Start = $AppFile.Name.IndexOf('DISTRI')
    $Stop = $AppFile.Name.IndexOf('_', $Start)
    return $AppFile.Name.Substring($Start, $Stop - $Start)
}

$ReplaceColl = @()

foreach ($AppFile in $AppFiles) {
    $AppName = get-AppNameFromFileName($AppFile)

    $FilesToReplace = Get-ChildItem -Path $Workspace -Filter "*_$($AppName)_*.app" -Recurse
    foreach ($FileToReplace in $FilesToReplace) {
        $Replace = @{
            "From" = $AppFile.FullName
            "To"   = $FileToReplace.FullName
        }
        $ReplaceColl += $Replace
    }
}


foreach ($ReplaceItem in $ReplaceColl) {
    $Item = Get-Item $ReplaceItem.To

    Remove-Item $ReplaceItem.To -Force

    Copy-Item -Path $ReplaceItem.From -Destination $Item.DirectoryName

}
