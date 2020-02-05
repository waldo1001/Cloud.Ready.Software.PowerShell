. (Join-path $PSScriptRoot '_Settings.ps1')

$LaunchJson = get-ChildItem -Path $BaseFolder launch.json -Recurse

if ($LaunchJson) {
    foreach ($Target in $Targets) {
        if ($Target -ne $BaseFolder) {
            $LaunchJson | Copy-Item -Destination (join-path $Target ".vscode") -Force -Verbose
        }
    }
}