. (Join-path $PSScriptRoot '_Settings.ps1')

$Message = 'Fixed CodeCop - Obsolete Fields'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git stage .
    & git commit -m "$Message"
    & git push
}