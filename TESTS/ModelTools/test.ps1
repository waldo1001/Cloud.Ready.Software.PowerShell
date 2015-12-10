$Model = [System.Reflection.Assembly]::LoadFrom('C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\microsoft.dynamics.nav.model.dll')
$ModelTools = [System.Reflection.Assembly]::LoadFrom('C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\microsoft.dynamics.nav.model.tools.dll')
$ModelParser = [System.Reflection.Assembly]::LoadFrom('C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\microsoft.dynamics.nav.model.Parser.dll')

$Objects = 'C:\_Powershell\Merge\Distri82ToNAV2016\Distri82_DistriObjects.txt'
$MyStream = new-object System.IO.Stream ($Objects)


