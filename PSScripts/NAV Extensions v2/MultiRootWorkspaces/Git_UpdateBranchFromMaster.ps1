. (Join-path $PSScriptRoot '_Settings.ps1')

$FromBranch = 'master'
$ToBranch = 'Release/6.3'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
    & git fetch
    & git pull origin "$FromBranch"
    & git push
}
