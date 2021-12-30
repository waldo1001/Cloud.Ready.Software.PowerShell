param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Distri'
)

Write-Host "Update branch from master"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

$FromBranch = 'master'
$ToBranch = read-host 'To Branch'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    
    & git checkout -q "$FromBranch"
    & git pull
    & git checkout -q "$ToBranch"
    & git fetch
    & git pull origin "$FromBranch"
    & git push

}