. (Join-path $PSScriptRoot '_Settings.ps1')
# . (Join-path $PSScriptRoot '_SettingsCustomers.ps1')


$ToBranch = 'v17prep'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
}