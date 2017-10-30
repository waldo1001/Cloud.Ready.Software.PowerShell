import-navmodules

find-module | where author -eq 'waldo' | Update-Module

$AppJson = Get-ObjectFromJSON '.\app.json' 
$LaunchJson = Get-ObjectFromJSON '.\.vscode\launch.json'

Start-NAVApplicationObjectInWebClient `
    -WebServerInstance $LaunchJson. `
    -WebClientType Web `
    -ObjectType Page `
    -ObjectID 70050000

