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


    $navModuleVersions = @()
    $useSyncSearchFallback = $false

    if (($useSyncSearchFallback -eq $false) -and (($Global:NAVJobManager -eq $null) -or ($Global:NAVJobManager.MVS -eq $null))) {
        Write-Verbose "Starting background search process because `$Global:NAVJobManager.MVS does not exist yet."
        Start-NAVVersionModuleSearch
    }
    
    if ($useSyncSearchFallback -eq $false) {
        # Wait if still caching in the background...
        Write-Verbose "Checking `$Global:NAVJobManager.MVS status."

        $writeWait = $true
        while (($Global:NAVJobManager.MVS.Jobs.Count -ne 0) -and ($Global:NAVJobManager.MVS.Errors.Count -eq 0)) {
            if ($writeWait) {
                Write-Verbose "NAV module versions are still being cached in the background. Waiting a second, please..."
                $writeWait = $false
            }
            Start-Sleep -Milliseconds 250
        }
    }

    if (($useSyncSearchFallback -eq $false) -and ($Global:NAVJobManager.MVS.Errors.Count -ne 0)) {
        $useSyncSearchFallback = $true
        Write-Verbose "Falling back to synchronous search because `$Global:NAVJobManager.MVS.Errors contains the following errors"
        foreach ($error in $Global:NAVJobManager.MVS.Errors) {
            Write-Verbose "`t - $error"
        }
    }
    
    if ($useSyncSearchFallback) {
        $navModuleVersions += Get-NAVModuleVersions 'Microsoft.Dynamics.Nav.Management.psm1' 'Microsoft.Dynamics.Nav.Management.dll' 'NAV Management'
        $navModuleVersions += Get-NAVModuleVersions 'Microsoft.Dynamics.NAV.Model.Tools.psd1' 'Microsoft.Dynamics.NAV.Model.Tools.dll' 'NAV Model Tools'
        $navModuleVersions += Get-NAVModuleVersions 'Microsoft.Dynamics.Nav.Apps.Tools.psd1' 'Microsoft.Dynamics.Nav.Apps.Tools.dll' 'NAV Apps Tools'
    } else {
        $navModuleVersions += $Global:NAVJobManager.MVS.Results
    }

    $modulesToImport = (Select-NAVVersion $navModuleVersions)
    
    foreach ($moduleToImport in $modulesToImport) {
        try {
            Import-Module $moduleToImport.ModuleFileFullName -DisableNameChecking -Global
            Write-Verbose "$($moduleToImport.ModuleTitle) module has been imported"
        } catch {
            Write-Error "$($moduleToImport.ModuleTitle) module has not been imported due to the following error: $($_.Exception.Message)"
        }
    }
}