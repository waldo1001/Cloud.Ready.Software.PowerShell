$Workspace = "C:\_Source\DistriApps\"
$BaseFolder = join-path $workspace 'BASE\App'
$SymbolFolder = '.alpackages'

$AppJsons = Get-ChildItem $Workspace -Recurse 'app.json'
$Targets = $AppJsons.directory.fullname
