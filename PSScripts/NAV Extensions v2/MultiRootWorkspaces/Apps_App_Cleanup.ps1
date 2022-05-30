. (Join-path $PSScriptRoot '_Settings.ps1')

foreach ($Target in $Targets) {
    write-Host $Target
    Get-ChildItem -Path $Target -Filter '*.app' -Recurse -Exclude "*\.appSourceCopPackages\*" | % {
        if ($_.FullName -like "*.appSourceCopPackages*"){
            write-Host -ForegroundColor Yellow "Skipped $($_.FullName)"
        } else {
            $_ | Remove-Item -Force -Verbose
        }
    }
}


