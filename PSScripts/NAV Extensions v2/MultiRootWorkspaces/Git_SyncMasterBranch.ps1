. (Join-path $PSScriptRoot '_Settings.ps1')

$MasterBranch = 'master'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$MasterBranch"
    & git pull
    & git push
}
