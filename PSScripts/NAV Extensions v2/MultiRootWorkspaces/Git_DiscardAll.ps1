. (Join-path $PSScriptRoot '_Settings.ps1')

$Message = 'Fixed CodeCop - Obsolete Fields'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git reset --hard
}