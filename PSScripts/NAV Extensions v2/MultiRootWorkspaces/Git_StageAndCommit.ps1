. (Join-path $PSScriptRoot '_Settings.ps1')

$Message = 'References to release-branch'
#$Message = 'Versions in App.json to 6.3'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location "$Target"
    
    & git stage .
    & git commit -m "$Message"
    & git push
}