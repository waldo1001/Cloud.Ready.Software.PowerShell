
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#navcontainerhelper
$FindModule = Find-Module 'navcontainerhelper'            
if($FindModule){
    write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
    Install-Module 'navcontainerhelper' -Force 
}

#CRS.NavContainerHelperExtension
$FindModule = Find-Module 'CRS.NavContainerHelperExtension'           
if($FindModule){
    write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
    Install-Module 'CRS.NavContainerHelperExtension' -Force 
}

