. (Join-path $PSScriptRoot '_SettingsCustomers.ps1')

$AppFiles = Get-ChildItem 'C:\Temp\apps'

function get-AppNameFromFileName($AppFile) {
    $Start = 29
    $Stop = $AppFile.Name.IndexOf('_', $Start)
    return $AppFile.Name.Substring($Start, $Stop - $Start)
}

function get-AppVersionFromFileName($AppFile){

    $Start = $AppFile.Name.IndexOf('_', 31)
    $Stop = $AppFile.Name.IndexOf('.', $Start + 1)
    $Major  = $AppFile.Name.Substring($Start + 1, $Stop - $Start - 1)

    $Start = $Stop
    $Stop = $AppFile.Name.IndexOf('.', $Start + 1)
    $Minor  = $AppFile.Name.Substring($Start + 1, $Stop - $Start - 1)

    return "$Major.$Minor"
}

$ReplaceColl = @()

foreach ($AppFile in $AppFiles) {
    $AppName = get-AppNameFromFileName($AppFile)
    $AppVersion = get-AppVersionFromFileName($AppFile)

    $FilesToReplace = Get-ChildItem -Path $Workspace -Filter "*_$($AppName)_*$($AppVersion)*.app" -Recurse
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

    write-host $ReplaceItem.To

    Remove-Item $ReplaceItem.To -Force

    Copy-Item -Path $ReplaceItem.From -Destination $Item.DirectoryName

}
