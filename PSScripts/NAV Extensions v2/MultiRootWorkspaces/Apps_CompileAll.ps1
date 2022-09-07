. (Join-path $PSScriptRoot '_Settings.ps1')

$cleansymbols = $false
$PublishToContainer = $null #'bccurrent'

# Start Script
$startTime = Get-Date

if ($cleansymbols){
    Write-Host "Cleanup Symbols" -ForegroundColor Yellow
    . (Join-path $PSScriptRoot 'Apps_Symbol_Cleanup.ps1')

    Write-Host "Download Symbols" -ForegroundColor Yellow
    . (Join-path $PSScriptRoot 'Apps_Symbol_Download.ps1')
}

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
$AllAppFiles | % {
    if (-not($_.FullName -like "*.appSourceCopPackages*")){
        $_ | Copy-Item -Destination $SymbolFolderForCompile -Force
    }
}


# compile
Write-Host "Compile all apps in the right order" -ForegroundColor Yellow
$compileFails = @()
$Paths | Sort ProcessOrder | % {
    Write-Host "  Compiling $($_.Path )" -ForegroundColor Gray 
    $appProjectFolder = [io.path]::GetDirectoryName($_.Path)
    
    $appfilename = (join-path $SymbolFolderForCompile "$($_.Publisher)_$($_.Name)_$($_.Version).app")
    $success = Compile-ALApp `
        -appProjectFolder $appProjectFolder `
        -appSymbolsFolder $SymbolFolderForCompile `
        -appOutputFile $appfilename `
        # -Verbose

    if ($success -and $PublishToContainer) {
        Publish-BcContainerApp `
            -containerName $PublishToContainer `
            -appFile $appfilename `
            -skipVerification `
            -syncMode ForceSync `
            -sync `
            -install `
            -scope Tenant
    }
        
    if (-not $success) {
        Write-Host "Failed to compile $($_.Path )" -ForegroundColor Red 
        $compileFails += $_
    }
}

$compileFails | % { 
        Write-Host "Failed compilation for: $($_.path) " -ForegroundColor Red 
}

$compileFails | Sort ProcessOrder | % {
    Write-Host " Retrying to compile $($_.Path )" -ForegroundColor Gray 
    
    $appProjectFolder = [io.path]::GetDirectoryName($_.Path)
    
    $appfilename = (join-path $SymbolFolderForCompile "$($_.Publisher)_$($_.Name)_$($_.Version).app")
    $success = Compile-ALApp `
        -appProjectFolder $appProjectFolder `
        -appSymbolsFolder $SymbolFolderForCompile `
        -appOutputFile $appfilename `
        -Verbose

    if ($success) {
        $compileFails.Remove($_)
    }
}

$Targets | % {
    $Translation = Get-ChildItem $_ -Filter "*.g.xlf" -Recurse
    if (!$Translation) {        
        Write-Host "No Translation found for $($_)" -ForegroundColor Red
    }
}

Write-Host "Copy Compiled Apps to symbol folders of apps that need it as dependencies" -ForegroundColor Yellow
foreach ($path in $paths) {
    foreach ($Dependency in $path.Dependencies) {
        $symbolfile = Get-ChildItem -Path $SymbolFolderForCompile -Filter "*_$($Dependency.name)_*"
        $Destination = join-path (get-item $path.path).Directory $SymbolFolder
        
        if ($symbolfile.FullName) {            
            # Write-host "copy-item $($symbolfile.FullName) -Destination $Destination" 
            copy-item -path $symbolfile.FullName -Destination $Destination
        } else {
            Write-host "Unable to copy $($Dependency.name)" -ForegroundColor red
        }
    }
}

$endTime = Get-Date

Write-Host "Elapsed time (Min): $(($endTime - $startTime).TotalMinutes)" -ForegroundColor Yellow