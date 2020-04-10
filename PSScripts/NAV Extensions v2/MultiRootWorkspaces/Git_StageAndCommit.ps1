. (Join-path $PSScriptRoot '_Settings.ps1')

$Message = 'Small change to trigger pipeline'

foreach ($Target in $Targets) {
    write-host $Target -ForegroundColor Green
    Set-Location "$Target/.."
    
    & git stage .
    & git commit -m "$Message"
    & git push
}