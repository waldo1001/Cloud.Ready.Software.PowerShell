#Remove Module Path
$ModulePaths = $env:PSModulePath -split ';'
$NewModulePaths = @()
foreach ($ModulePath in $ModulePaths){
    if (!($ModulePath.Contains('Cloud.Ready.Software.PowerShell'))){
        $NewModulePaths += $ModulePath
    }
}

$NewPSModulePath = ($NewModulePaths | select -Unique) -join ';'
[environment]::SetEnvironmentVariable('PSModulePath',  $NewPSModulePath, 'Machine')
$env:PSModulePath = $NewPSModulePath