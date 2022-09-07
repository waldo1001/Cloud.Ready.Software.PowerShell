$Workspace = "C:\_Source\iFacto\DistriApps\"
$BaseFolder = join-path $workspace 'BASE\App'
$SymbolFolder = '.alpackages'

$AppJsons = Get-ChildItem $Workspace -Recurse 'app.json'

$targetRepos = (Get-ChildItem $Workspace -Recurse -Hidden -Include '.git').Parent.FullName
$Targets = $AppJsons.directory.fullname

$AppSourceCopPackagesFolder = '.appSourceCopPackages'