. (Join-path $PSScriptRoot '_Settings.ps1')

foreach ($Target in $Targets) {
    $AppSourceCopPackagesFolderTarget = Join-Path $Target $AppSourceCopPackagesFolder
    $SymbolFolderTarget = get-item (join-path $target $SymbolFolder)
    if (Test-Path $AppSourceCopPackagesFolderTarget) {
        $apps = Get-ChildItem $AppSourceCopPackagesFolderTarget -Filter '*.app'
        foreach($app in $apps){
            Write-Host -ForegroundColor Green "Copy $($app.Name) --> $SymbolFolderTarget"
            Copy-Item -Path $app.FullName -Destination $SymbolFolderTarget
        }
    }
}