. (Join-path $PSScriptRoot '_Settings.ps1')
# . (Join-path $PSScriptRoot '_SettingsCustomers.ps1')

foreach ($Target in $Targets) {
    write-Host $Target
    Get-ChildItem -Path (join-path $Target $SymbolFolder) -Filter '*.app' | % {
        $_ | Remove-Item -Force -Verbose
    }
}


