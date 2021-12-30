param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Distri'
)

Write-Host "Discard all changes for $Type"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

$MasterBranch = 'master'
$NewBranch = Read-Host 'New Branch'

foreach ($Target in $targetRepos) {
    write-host $Target -ForegroundColor Green
    Set-Location $Target
    & git checkout -q "$MasterBranch"
    & git pull
    & git push
    & git checkout -q -b "$NewBranch"
    & git checkout -q "$NewBranch"
    & git push -u origin "$NewBranch"
}
