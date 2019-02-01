function Install-NCHDependentModules {
    param(        
        [Parameter(Mandatory = $false)]
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [Switch] $ContainerModulesOnly
    )

    if (!$ContainerModulesOnly) {
        $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        
        #navcontainerhelper
        $FindModule = Find-Module 'navcontainerhelper'            
        if($FindModule){
            write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
            Install-Module 'navcontainerhelper' -Force 
        }
        
        #CRS.NavContainerHelperExtension .NavContainerHelperExtension'           
        if($FindModule){
            write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
            Install-Module 'CRS.NavContainerHelperExtension' -Force             
        }
    }

    if ($ContainerName) {
        #$Session = Get-NavContainerSession -containerName $ContainerName
        #Invoke-Command -Session $Session -ScriptBlock {
        Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {
            param(
                $ContainerName
            )
            function InstallModuleFromPSGallery ([String] $Module) {
                $FindModule = Find-Module $Module
                write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) from $($FindModule.Repository) on Container $ContainerName" -ForegroundColor Gray
                Install-Module $Module -Force 
            }

            Write-host "Installing dependent modules on Container $ContainerName" -ForegroundColor Green
            
            $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

            InstallModuleFromPSGallery -Module Cloud.Ready.Software.NAV 
            InstallModuleFromPSGallery -Module Cloud.Ready.Software.SQL 
            InstallModuleFromPSGallery -Module Cloud.Ready.Software.Windows 
            InstallModuleFromPSGallery -Module Cloud.Ready.Software.PowerShell 
        } -ArgumentList $ContainerName
    }

}