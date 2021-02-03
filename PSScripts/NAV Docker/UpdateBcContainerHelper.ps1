$module = 'BcContainerHelper'

$Start = Get-date

$currentVersion = (Get-InstalledModule -Name $module -AllVersions).Version
$moduleInfos = Find-Module -Name $module
 
if ($null -eq $currentVersion) { 
    Install-Module -Name $module -Force 
}
elseif ($currentVersion.count -gt 1) {
    Get-InstalledModule -Name $module -AllVersions | Where-Object { $_.Version -ne $moduleInfos.Version } | Uninstall-Module -Force
    Install-Module -Name $module -Force
}
elseif ($moduleInfos.Version -eq $currentVersion) {
    Write-Host -ForegroundColor Green "$($moduleInfos.Name) already installed in the latest version ($currentVersion. Release date: $($moduleInfos.PublishedDate))" 
}
else {
    Update-Module -Name $module -Force
}

$End = get-date

write-host "Elapsed Time = $(($End - $Start).Seconds) seconds"