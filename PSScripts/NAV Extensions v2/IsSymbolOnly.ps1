### Change this
$CodeAnalysisDLLPath = "C:\bcartifacts.cache\sandbox\21.2.49946.51980\platform\ServiceTier\program files\Microsoft Dynamics NAV\210\Service\Microsoft.Dynamics.Nav.CodeAnalysis.dll"
$AppFilePath         = "C:\_Source\iFacto\DistriApps\SALESPURCHBE\App\iFacto Business Solutions NV_Distri Sales and Purchase (Belgium)_21.2.0.0.app"
$AppFilePath         = "C:\_Source\Community\waldo.BCPerfTool\BCPerfTool\waldo_BCPerfTool_1.0.0.0.app"

### Run This
add-type -Path "$($CodeAnalysisDLLPath)"
$NavXFilepath = "$($AppFilePath)"

Write-Host "*** Read App Manifest: [$($NavXFilepath)]."
$FileStream = [System.IO.FileStream]::new($NavXFilepath ,[System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)                           
$Package = [Microsoft.Dynamics.Nav.CodeAnalysis.Packaging.NavAppPackageReader]::Create($FileStream)                              

$Results = $Package.ReadSourceCodeFilePaths()
if ($Results.Count -eq 0){
    Write-Warning "*** The App will fail the 'IsSymbolOnlyCheck'"
} else {
    Write-Host "*** The App passed the 'IsSymbolOnlyCheck' ! " -ForegroundColor Green
}
$FileStream.Close();

$Package | fl
