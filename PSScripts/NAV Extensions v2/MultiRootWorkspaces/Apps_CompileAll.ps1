. (Join-path $PSScriptRoot '_Settings.ps1')

Write-Host "Get-AppDependencies" -ForegroundColor Yellow
$Paths = Get-AppDependencies -Path $Workspace -Type ALFolders

Write-Host "Set location to workspace" -ForegroundColor Yellow
Set-location $Workspace

Write-Host "Delete all app files (excl. symbols)" -ForegroundColor Yellow
$Targets | % {
    Get-ChildItem $_ -Filter "*.app" | Remove-Item -Force
}


Write-Host "Build one folder with all symbols" -ForegroundColor Yellow
$SymbolFolderForCompile = Join-Path $Workspace ".symbols"

Remove-Item $SymbolFolderForCompile -Force -Recurse
New-Item -Path $SymbolFolderForCompile -ItemType Directory -Force

$AllAppFiles = Get-ChildItem $WorkSpace -recurse -filter '*.app'
$AllAppFiles | Copy-Item -Destination $SymbolFolderForCompile -Force


# compile
Write-Host "Compile all apps in the right order" -ForegroundColor Yellow
$compileFails = @()
$Paths | Sort ProcessOrder | % {
    Write-Host "  Compiling $($_.Path )" -ForegroundColor Gray 
    
    $appProjectFolder = [io.path]::GetDirectoryName($_.Path)
    
    $success = Compile-ALApp `
        -appProjectFolder $appProjectFolder `
        -appSymbolsFolder $SymbolFolderForCompile `
        -appOutputFile (join-path $SymbolFolderForCompile "$($_.Publisher)_$($_.Name)_$($_.Version).app") `
        -Verbose
    
    if (-not $success) {
        $compileFails += $appProjectFolder
    }
}
$compileFails | % { Write-Host "Failed compilation for: $_ " -ForegroundColor Red }
#Check Compilations
$Targets | % {
    $Translation = Get-ChildItem $_ -Filter "*.g.xlf" -Recurse
    if (!$Translation) {        
        Write-Error "No Translation found for $($_)"
    }
}




Write-Host "Copy Compiled Apps to symbol folders of apps that need it as dependencies" -ForegroundColor Yellow
foreach ($path in $paths) {
    foreach ($Dependency in $path.Dependencies) {
        $symbolfile = Get-ChildItem -Path $SymbolFolderForCompile -Filter "*_$($Dependency.name)_*"
        $Destination = join-path (get-item $path.path).Directory $SymbolFolder
        
        copy-item $symbolfile.FullName -Destination $Destination
    }
}
