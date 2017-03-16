function Get-NAVModuleAdminVersions {
    <#
        .SYNOPSIS
        Find and return NAV versions and module paths.
        .DESCRIPTION
        Find and return all NAV versions and module paths inside the paths specified in $searchIn.
        .EXAMPLE
        
    #>

    [CmdletBinding()]
    param (

        [parameter(Mandatory=$false)]
        [String]$navMgtModuleName="Microsoft.Dynamics.Nav.Management.psm1",
        
        [parameter(Mandatory=$false)]
        [String]$navMgtModuleDllName="Microsoft.Dynamics.Nav.Management.dll",
        
        [parameter(Mandatory=$false)]
        [String[]]$searchIn
        
    )

    $retVal = @{}

    if ($searchIn -eq $null) {
        $searchIn = @( Join-Path $env:ProgramFiles 'Microsoft Dynamics NAV' )
    }

    foreach ($searchPath in $searchIn) {
        
        Write-Verbose "Searching in $searchPath, please wait a second..."
        $modules = Get-ChildItem -Path $searchPath -Filter $navMgtModuleName -Recurse -ErrorAction SilentlyContinue -ErrorVariable longPathError
        
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
                $dllPath = Join-Path $moduleDir $navMgtModuleDllName
                $dll = Get-Item $dllPath
                $version = $dll | ForEach-Object { $_.VersionInfo.ProductVersion }

                if (!$retVal.ContainsKey($version)) {
                    $retVal.Add($version, $modulePath) 
                }

            }
        }
    }

    return $retVal
}