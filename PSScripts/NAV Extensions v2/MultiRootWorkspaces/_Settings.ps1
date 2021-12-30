$Workspace = "C:\_Source\iFacto\DistriApps\"
$BaseFolder = join-path $workspace 'LICENSING\App'
$SymbolFolder = '.alpackages'

$AppJsons = Get-ChildItem $Workspace -Recurse 'app.json'

$targetRepos = (Get-ChildItem $Workspace -Recurse -Hidden -Include '.git').Parent.FullName
$Targets = $AppJsons.directory.fullname
