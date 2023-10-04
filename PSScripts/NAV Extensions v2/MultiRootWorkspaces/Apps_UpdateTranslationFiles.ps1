. (Join-path $PSScriptRoot '_Settings.ps1')

$Translationsfiles = Get-ChildItem "C:\Temp\Translations"
$TranslationsSubDir = "Translations"

$AppJsonFiles = (Get-ChildItem -Recurse -Path $Workspace -Filter "app.json")

$Apps =
    foreach($AppJsonFile in $AppJsonFiles)
    {
        $AppJson = Get-Content $AppJsonFile.FullName -Raw | ConvertFrom-Json

        [pscustomobject] @{
                            "Name" = $AppJson.name
                            "Path" = $AppJsonFile.Directory.FullName
                        }
    }

foreach ($Translationsfile in $Translationsfiles) {
    $filename = $Translationsfile.Name
    $appname = $filename.Substring(0, $filename.IndexOf('.'))

    $App = $Apps | where Name -ieq $appname

    if (-not $App) {
        $App = $Apps | where Name -like "*$($appname)*"
    }

    if (-not $App) {
        Write-Error "App $appname not found"
        continue
    }
    
    $DestinationFolder = Join-Path $App.Path $TranslationsSubDir
    write-host "Move-Item -Path $($Translationsfile.FullName) -Destination $($DestinationFolder) -Force"  -ForegroundColor Green
    Move-Item -Path $Translationsfile.FullName -Destination $DestinationFolder -Force
}