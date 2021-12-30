param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Distri'
)

Write-Host "Discard all changes for $Type"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

$ToBranch = Read-host 'To Branch'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$ToBranch"
}