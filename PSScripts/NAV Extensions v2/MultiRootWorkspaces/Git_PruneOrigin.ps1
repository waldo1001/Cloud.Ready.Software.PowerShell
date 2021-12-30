param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Customer'
)

Write-Host "git remote prune origin"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git remote prune origin
}