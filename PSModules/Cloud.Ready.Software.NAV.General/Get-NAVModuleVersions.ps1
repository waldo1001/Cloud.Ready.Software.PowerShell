function Get-NAVModuleVersions {
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .EXAMPLE
        
    #>

    [CmdletBinding()]
    param (
        
        [parameter(Mandatory=$true)]
        [String]$navModuleName,
        
        [parameter(Mandatory=$true)]
        [String]$navModuleDllName,
        
        [parameter(Mandatory=$false)]
        [String]$navModuleTitle,

        [parameter(Mandatory=$false)]
        [String[]]$searchIn
        
    )

    $retVal = @()
    $uniqueVersionList = @{}

    if ([string]::IsNullOrEmpty($navModuleTitle)) {
        $navModuleTitle = $navModuleName
    }

    if ($searchIn -eq $null) {
        $searchIn = @( (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Dynamics NAV'), (Join-Path $env:ProgramFiles 'Microsoft Dynamics NAV') )
    }

    foreach ($searchPath in $searchIn) {
        
        Write-Verbose "Searching in $searchPath, please wait a second..."
        $modules = Get-ChildItem -Path $searchPath -Filter $navModuleName -Recurse -ErrorAction SilentlyContinue -ErrorVariable longPathError
    
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
                $dllPath = Join-Path $moduleDir $navModuleDllName
                $dll = Get-Item $dllPath | Select-Object -First 1
                $version = $dll.VersionInfo.ProductVersion

                $versionModuleInfo = New-Object PSObject
                $versionModuleInfo | Add-Member NoteProperty ModuleTitle $navModuleTitle
                $versionModuleInfo | Add-Member NoteProperty VersionNo $version
                $versionModuleInfo | Add-Member NoteProperty ModuleFileName $navModuleName
                $versionModuleInfo | Add-Member NoteProperty ModuleFileFullName $modulePath
                $versionModuleInfo | Add-Member NoteProperty ModuleDllFileName $navModuleDllName
                $versionModuleInfo | Add-Member NoteProperty ModuleDllFileName $navModuleDllName
                $versionModuleInfo | Add-Member NoteProperty ModuleDirectory $moduleDir
                
                if (!$uniqueVersionList.ContainsKey($version)) {                    
                    $uniqueVersionList.Add($version, $versionModuleInfo) 
                    $retVal += $versionModuleInfo
                }

            }
        }
    }

    return $retVal
}