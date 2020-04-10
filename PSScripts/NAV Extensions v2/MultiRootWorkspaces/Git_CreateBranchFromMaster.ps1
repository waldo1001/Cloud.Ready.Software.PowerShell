. (Join-path $PSScriptRoot '_Settings.ps1')

$MasterBranch = 'master'
$NewBranch = 'Release/5.1'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$MasterBranch"
    & git pull
    & git push
    & git checkout -q -b "$NewBranch"
    & git checkout -q "$NewBranch"
    & git push -u origin "$NewBranch"
}
