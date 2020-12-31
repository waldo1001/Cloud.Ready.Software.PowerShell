. (Join-path $PSScriptRoot '_Settings.ps1')

foreach ($Target in $Targets) {
    write-Host $Target
    Get-ChildItem -Path $Target -Filter '*.app' -Recurse | % {
        $_ | Remove-Item -Force -Verbose
    }
}


