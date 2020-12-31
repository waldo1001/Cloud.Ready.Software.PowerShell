$Workspace = "C:\_Source\iFacto\Customers\"
$BaseFolder = join-path $workspace 'All in 1\App'
$SymbolFolder = '.alpackages'

$AppJsons = Get-ChildItem $Workspace -Recurse 'app.json'

$targetRepos = (Get-ChildItem $Workspace -Recurse -Hidden -Include '.git').Parent.FullName
$Targets = $AppJsons.directory.fullname
