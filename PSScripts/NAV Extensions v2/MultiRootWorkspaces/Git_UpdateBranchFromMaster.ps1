. (Join-path $PSScriptRoot '_Settings.ps1')

$FromBranch = 'master'
$ToBranch = 'Release/5.0'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
    & git pull origin "$FromBranch"
    & git push
}
