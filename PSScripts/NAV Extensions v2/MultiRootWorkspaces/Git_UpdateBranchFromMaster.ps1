. (Join-path $PSScriptRoot '_Settings.ps1')
# . (Join-path $PSScriptRoot '_SettingsCustomers.ps1')

$FromBranch = 'master'
$ToBranch = 'waldo'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
    & git fetch
    & git pull origin "$FromBranch"
    & git push

}