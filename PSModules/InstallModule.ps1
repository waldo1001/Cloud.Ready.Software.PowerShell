if (!($env:PSModulePath.ToString().Contains($PSScriptRoot))){
    [environment]::SetEnvironmentVariable('PSModulePath',  $env:PSModulePath + ';' + $PSScriptRoot, 'Machine')
    $env:PSModulePath = $env:PSModulePath + ';' + $PSScriptRoot
}

Write-host "Loading Cloud.Ready.Software.NAV..." -ForegroundColor Green
Import-module Cloud.Ready.Software.NAV -Force 
Write-host "Loading Cloud.Ready.Software.PowerShell..." -ForegroundColor Green
Import-module Cloud.Ready.Software.PowerShell -Force
Write-host "Loading Cloud.Ready.Software.SQL..." -ForegroundColor Green
Import-module Cloud.Ready.Software.SQL -Force
Write-host "Loading Cloud.Ready.Software.Windows..." -ForegroundColor Green
Import-module Cloud.Ready.Software.Windows -Force

