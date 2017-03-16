function Import-NAVModules {

    <#
        .SYNOPSIS
        Find and import NAV modules globally.
        .DESCRIPTION
        Find and import all NAV modules available in the predefined paths.
        If multiple module versions present, non-GUI dialog will be shown to let a user select the desired desired version.
        Imported modules will be present in the global session context.
        .EXAMPLE
        Import-NAVModules
    #>

    [CmdletBinding()]
    param (
        
        [parameter(Mandatory=$false)]
        [string]$navVersion=$null,
        
        [parameter(Mandatory=$false)]
        [String[]]$searchInNavAdminModule,
        
        [parameter(Mandatory=$false)]
        [String[]]$searchInNavToolsModule

    )

    $navAdminVersions = Get-NAVModuleAdminVersions -searchIn $searchInNavAdminModule
    $navToolVersions = Get-NAVModuleToolVersions -searchIn $searchInNavToolsModule

    # Import NAV Administration module.
    $moduleTitle = "NAV Administration"
    try {
        if ([string]::IsNullOrEmpty($navVersion)) {
            $navAdminVersion = Select-NAVModuleVersion -versions $navAdminVersions -importType $moduleTitle
            $navVersion = $navAdminVersion.Name
        } else {
            if ($navAdminVersions.ContainsKey($navVersion)) {
                $navAdminVersion = $navAdminVersions[$navVersion]
            } else {
                Write-Error "Can not find $moduleTitle module version no. $navVersion"
            }
        }
        Import-Module $navAdminVersion.Value -DisableNameChecking -Global
        Write-Host "$moduleTitle module has been imported" -ForegroundColor Green

    } catch {
        Write-Host "$moduleTitle processing error: $($_.Exception.Message)" -ForegroundColor Red
    }

    if ([string]::IsNullOrEmpty($navVersion)) {
        $navVersion = Select-NAVModuleVersion -versions $navToolVersions -importType "NAV Client Tools"
        $navVersion = $navVersion.Name
    }

    # Import client tools of the same version.
    if ($navToolVersions.ContainsKey($navVersion)) {
    
        $navTool = $navToolVersions[$navVersion]
        $navTool.GetEnumerator() | ForEach-Object { 
            Import-Module $_.Value -DisableNameChecking -Global
            Write-Host "$($_.Name) module has been imported" -ForegroundColor Green
        }

    } else {
        Write-Warning "NAV client tools for selected version are not present or have not been found."
    }

}