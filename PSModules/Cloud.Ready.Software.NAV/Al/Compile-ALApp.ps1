
function Compile-ALApp {
    [CmdletBinding()]
    param(
        [string] $appProjectFolder,        
        [string] $appSymbolsFolder,        
        [string] $appOutputFile,
        [bool] $GenerateReportLayoutParam,
        [bool] $EnableCodeCop,
        [bool] $EnableAppSourceCop,    
        [bool] $EnablePerTenantExtensionCop,     
        [bool] $EnableUICop,     
        [string] $rulesetFile,     
        [bool] $nowarn,     
        [string] $assemblyProbingPaths  
    )

    $alc = get-childitem -Path "$env:USERPROFILE\.vscode\extensions\*\bin\win32" -Recurse alc.exe | select -First 1
    Write-Verbose "found $($alc.fullname)"

    # Remove translation file
    Get-ChildItem -path $appProjectFolder -Recurse -filter "*.g.xlf" | Remove-Item -Force | Write-Verbose
    
    $alcParameters = @("/project:$appProjectFolder", "/packagecachepath:$appSymbolsFolder", "/out:$appOutputFile")
    if ($GenerateReportLayoutParam) {
        $alcParameters += @($GenerateReportLayoutParam)
    }
    if ($EnableCodeCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.CodeCop.dll')")
    }
    if ($EnableAppSourceCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.AppSourceCop.dll')")
    }
    if ($EnablePerTenantExtensionCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.PerTenantExtensionCop.dll')")
    }
    if ($EnableUICop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.UICop.dll')")
    }

    if ($rulesetFile) {
        $alcParameters += @("/ruleset:$rulesetfile")
    }

    if ($nowarn) {
        $alcParameters += @("/nowarn:$nowarn")
    }

    if ($assemblyProbingPaths) {
        $alcParameters += @("/assemblyprobingpaths:$assemblyProbingPaths")
    }

    Write-Verbose "alc.exe $([string]::Join(' ', $alcParameters))"

    & $alc.fullname $alcParameters | Write-Verbose

    # Check Translationfile
    $TranslationFile = Get-ChildItem -path $appProjectFolder -Recurse -filter "*.g.xlf"
    if ($TranslationFile) {
        Write-Host "Successfully compiled $appProjectFolder" -ForegroundColor Green
        return $true
    }
    else {
        write-error "Compilation ended with errors"
        return $false
    }
    
}