param (
    [validateset('Distri', 'Customer')]
    [String] $Type = 'Distri'
)

Write-Host "Copy Launch.json for $Type"

switch ($Type) {
    'Distri' { . (Join-path $PSScriptRoot '_Settings.ps1') }
    'Customer' { . (Join-path $PSScriptRoot '_SettingsCustomers.ps1') }
}

Write-host "Base folder: $($BaseFolder)"

$LaunchJson = get-ChildItem -Path $BaseFolder launch.json -Recurse

if ($LaunchJson) {
    foreach ($Target in $Targets) {
        if ($Target -ne $BaseFolder) {
            $LaunchJson | Copy-Item -Destination (join-path $Target ".vscode") -Force -Verbose
        }
    }
}