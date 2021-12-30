#Source: https://raw.githubusercontent.com/itpro-tips/PowerShell-Toolbox/master/Update-AllPowerShellModules.ps1

function Update-PSModule() {
    param (
        [Parameter()]
        [String] $ModuleName
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    $Start = Get-date
    
    $currentVersion = (Get-InstalledModule -Name $moduleName -AllVersions).Version
    $moduleNameInfos = Find-Module -Name $moduleName
     
    if ($null -eq $currentVersion) { 
        Write-Host -ForegroundColor Cyan "$($moduleNameInfos.Name) - Install from PowerShellGallery version $($moduleNameInfos.Version). Release date: $($moduleNameInfos.PublishedDate)"
        Install-Module -Name $moduleName -Force 
    }
    elseif ($currentVersion.count -gt 1) {
        Write-Warning "$module is installed in $($currentVersion.count) versions (versions: $($currentVersion -join ' | '))"
        Write-Host -ForegroundColor Cyan "Uninstall previous $module versions"

        Get-InstalledModule -Name $moduleName -AllVersions | Where-Object { $_.Version -ne $moduleNameInfos.Version } | Uninstall-Module -Force
        Install-Module -Name $moduleName -Force
    }
    elseif ($moduleNameInfos.Version -eq $currentVersion) {
        Write-Host -ForegroundColor Green "$($moduleNameInfos.Name) already installed in the latest version ($currentVersion. Release date: $($moduleNameInfos.PublishedDate))" 
    }
    else {
        Write-Host -ForegroundColor Cyan "$($moduleNameInfos.Name) - Update from PowerShellGallery from version $currentVersion to $($moduleNameInfos.Version). Release date: $($moduleNameInfos.PublishedDate)" 

        Update-Module -Name $moduleName -Force
    }
    
    $End = get-date
    
    write-host "Elapsed Time = $(($End - $Start).Seconds) seconds"
}

Update-PSModule -ModuleName 'BcContainerHelper'

# upgrade all modules:

# Get-InstalledModule | % {
#     Update-PSModule -ModuleName $_.Name
# }