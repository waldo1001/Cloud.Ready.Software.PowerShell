$code =
{
 Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1' -WarningAction SilentlyContinue | out-null
 Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1' -WarningAction SilentlyContinue | Out-Null
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Load NAV 2015 CmdLets',$code,$null)

$code =
{
 Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1' -WarningAction SilentlyContinue | out-null
 Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1' -WarningAction SilentlyContinue | Out-Null
}
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Load NAV 2016 CmdLets',$code,$null)

$code =
{ 
    Get-ChildItem 'S:\PowerShellScripts\PSFunctions' -Recurse -File | foreach {import-module $_.fullname}
}
$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Load waldo functions', $code, $null )
