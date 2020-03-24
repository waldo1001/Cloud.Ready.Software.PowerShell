. (Join-path $PSScriptRoot '_Settings.ps1')

$ToBranch = 'master'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
}
