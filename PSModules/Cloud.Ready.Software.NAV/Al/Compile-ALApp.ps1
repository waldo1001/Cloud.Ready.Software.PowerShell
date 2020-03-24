function Compile-ALApp {

    params(
        [string] $Project
    )

    $alc = get-childitem -Path "$env:USERPROFILE\.vscode\extensions" -Recurse alc.exe | select -First 1

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

    Write-Host "alc.exe $([string]::Join(' ', $alcParameters))"

    & .\alc.exe $alcParameters
}