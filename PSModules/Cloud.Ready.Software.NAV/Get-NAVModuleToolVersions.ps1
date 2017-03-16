function Get-NAVModuleToolVersions {
    <#
        .SYNOPSIS
        Find and return versions and module paths of NAV client tools.
        .DESCRIPTION
        Find and return all versions and module paths of NAV client tools inside the paths specified in $searchIn.
        .EXAMPLE
        
    #>

    [CmdletBinding()]
    param (
        
        [parameter(Mandatory=$false)]
        [String]$navModelModuleName="Microsoft.Dynamics.NAV.Model.Tools.psd1",
        
        [parameter(Mandatory=$false)]
        [String]$navModelModuleDllName="Microsoft.Dynamics.NAV.Model.Tools.dll",
        
        [parameter(Mandatory=$false)]
        [String]$navAppsModuleName="Microsoft.Dynamics.Nav.Apps.Tools.psd1",
        
        [parameter(Mandatory=$false)]
        [String]$navAppsModuleDllName="Microsoft.Dynamics.Nav.Apps.Tools.dll",
        
        [parameter(Mandatory=$false)]
        [String[]]$searchIn
        
    )

    $retVal = @{}

    if ($searchIn -eq $null) {
        $searchIn = @( Join-Path ${env:ProgramFiles(x86)} 'Microsoft Dynamics NAV' )
    }

    For ($i=0; $i -lt 2; $i++) {

        switch ($i) {
            0 {
                $moduleName = $navModelModuleName
                $moduleDllName = $navModelModuleDllName
            }
            1 {
                $moduleName = $navAppsModuleName
                $moduleDllName = $navAppsModuleDllName
            }
        }

        foreach ($searchPath in $searchIn) {
            
            Write-Verbose "Searching in $searchPath, please wait a second..."
            $modules = Get-ChildItem -Path $searchPath -Filter $moduleName -Recurse -ErrorAction SilentlyContinue -ErrorVariable longPathError
        
            foreach ($errorRecord in $longPathError)
            {
                if ($errorRecord.Exception -is [System.IO.PathTooLongException])
                {
                    Write-Warning "Path too long in directory '$($errorRecord.TargetObject)'."
                }
                else
                {
                    Write-Error -ErrorRecord $errorRecord
                }
            }

            if ($modules -ne $null) {
                foreach ($module in $modules) {
                    $modulePath = $module.FullName
                    $moduleDir = $module.Directory.FullName
                    $dllPath = Join-Path $moduleDir $moduleDllName
                    $dll = Get-Item $dllPath
                    $version = $dll | ForEach-Object { $_.VersionInfo.ProductVersion }

                    $modulePair = @{ $moduleName = $modulePath }


                    if (!$retVal.ContainsKey($version)) {
                        $retVal.Add($version, $modulePair) 
                    } else {
                        if (!$retVal[$version].ContainsKey($moduleName)) {
                            $retVal[$version].Add($moduleName, $modulePath)
                        }
                    }
                }
            }
        }
    }

    return $retVal
}

