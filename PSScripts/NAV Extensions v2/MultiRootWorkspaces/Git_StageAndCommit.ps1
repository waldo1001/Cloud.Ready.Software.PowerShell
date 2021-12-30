param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Distri'
)

Write-Host "Stage and commit for $Type"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

$Message = Read-host "Commit Message"

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location "$Target"
    
    & git stage .
    & git commit -m "$Message"
    & git push
}