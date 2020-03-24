. (Join-path $PSScriptRoot '_Settings.ps1')

Write-Host "Get-AppDependencies" -ForegroundColor Yellow

$Paths = Get-AppDependencies -Path $Workspace -Type ALFolders

# Get-AppDependencies -Path $Target | ForEach-Object {
#     $_.Path
# }


Set-location $Workspace

# Delete all app files
$Targets | % {
    Write-Host -ForegroundColor Green "Removing app files from $($_)" 
    
    Get-ChildItem $_ -Filter "*.dep.app" | Remove-Item -Force
}

# Delete all .g.xlf files
# $Targets | % {
#     Write-Host -ForegroundColor Green "Removing translation files from $($_)" 
    
#     Get-ChildItem $_ -Filter "*.g.xlf" -Recurse | Remove-Item -Force
# }

# Build folder with all symbols
$SymbolFolder = Join-Path $Workspace ".symbols"
New-Item -Path $SymbolFolder -ItemType Directory -Force

$AllAppFiles = Get-ChildItem $WorkSpace -recurse -filter '*.app'
$AllAppFiles | Copy-Item -Destination $SymbolFolder -Force -

# compile
$Paths | Sort ProcessOrder | % {
    Write-Host -ForegroundColor Green "Compiling $($_.Path )" 
    
    $appProjectFolder = [io.path]::GetDirectoryName($_.Path)

    Compile-ALApp `
        -appProjectFolder $appProjectFolder `
        -appSymbolsFolder $SymbolFolder `
        -appOutputFile (join-path $SymbolFolder "$($_.Publisher)_$($_.Name)_$($_.Version).app") 
}

# Remove symbolfolder
Remove-Item $SymbolFolder -Force -Recurse