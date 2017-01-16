function Import-NAVModules {
    [cmdletbinding()]
    param(
         [String] $Version
    )

    #Find Server Modules
    if ($Version) {
        $Versions = Get-ChildItem (join-path "$env:ProgramFiles\Microsoft Dynamics NAV\" $Version)
    } else {
        $Versions = Get-ChildItem "$env:ProgramFiles\Microsoft Dynamics NAV\"
    
        if ($ServerVersions.count -gt 1){
            Write-Warning "Multiple versions present: $($Versions.PSChildName -join ','). Current version: $($Versions[0].PSChildName)"                
            $Version = $Versions[0].PSChildName        
        } Else {       
            $Version = $Versions.PSChildName
        }
    }

    $NAVAdminModulePath = Get-Item "$env:ProgramFiles\Microsoft Dynamics NAV\$version\Service\NavAdminTool.ps1"  

    #Find Client Modules
    if ([Environment]::Is64BitProcess){
        $RtcKey = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft Dynamics NAV'
    }
    else {
        $RtcKey = 'HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV'
    }
        

    $ClientPath = (Get-ItemProperty (Join-Path (Join-Path $RtcKey $Version) 'RoleTailored Client')).Path
    

    #Import ..
    #$NAVAdminModulePath = Get-Item "$env:ProgramFiles\Microsoft Dynamics NAV\$version\Service\Microsoft.Dynamics.Nav.Management.dll"
    #Write-Host -ForegroundColor Green "Import Server Module from $($NAVAdminModulePath.Directory)"
    #Write-Host -ForegroundColor Gray $NAVAdminModulePath
    #Import-Module $NAVAdminModulePath -WarningAction SilentlyContinue -Scope Global -Force

    #Write-Host -ForegroundColor Green "Import Client Modules from $ClientPath"
    #Write-Host -ForegroundColor Gray (Join-path $ClientPath 'Microsoft.Dynamics.NAV.Model.Tools.psd1')
    #Import-Module (Join-path $ClientPath 'Microsoft.Dynamics.NAV.Model.Tools.psd1') -WarningAction SilentlyContinue -Scope Global -Force    
    #Write-Host -ForegroundColor Gray (Join-Path $ClientPath 'Microsoft.Dynamics.Nav.Apps.Tools.psd1')
    #Import-Module (Join-Path $ClientPath 'Microsoft.Dynamics.Nav.Apps.Tools.psd1') -WarningAction SilentlyContinue -Scope Global -Force

    $CmdLets = @()
    if ($NAVAdminModulePath) {
        $CmdLets += "Import-Module '$NAVAdminModulePath' -WarningAction SilentlyContinue -Scope Global -Force| out-null"
    }
    if ($ClientPath){
    $CmdLets += "Import-Module '$(Join-path $ClientPath 'Microsoft.Dynamics.NAV.Model.Tools.psd1')' -WarningAction SilentlyContinue -Scope Global -Force | out-null"
    $CmdLets += "Import-Module '$(Join-Path $ClientPath 'Microsoft.Dynamics.Nav.Apps.Tools.psd1')' -WarningAction SilentlyContinue -Scope Global -Force | out-null"
    }
    $CmdLets += "Get-Command -Module Microsoft.Dynamics.Nav.* | sort Module"
    $cmdlets | clip.exe
    
    Write-Host -ForegroundColor Green 'Following statements were copied to your clipboard. Execute them to load it in your runspace.  (At this point, I didn''t find a way to Import the modules in the Global context decently)'
    $CmdLets | Foreach{ Write-Host -ForegroundColor Gray "  $_"}
    
}
