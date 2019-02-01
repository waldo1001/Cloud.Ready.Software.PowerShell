function  Clean-CustomNAVAppsOnDocker {
    <#
    .SYNOPSIS
    Removing all non-Microsoft Apps from a certain Docker Container.  Warning: intentionally deletes the data!
    
    .DESCRIPTION
    Removes the NAVApps that are not created by publisher "Microsoft"
    Needs to "navcontainerhelper"
    
    .EXAMPLE
    Clean-CustomNAVAppsOnDocker -ContainerName navserver
    
    .NOTES
    Assumes the "navcontainerhelper" is installed.  If not installed, please install it by "Install-module navcontainerhelper -force"
    #>

    param(
        [String] $ContainerName
    )

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {        
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        $Apps = Get-NAVAppInfo -ServerInstance NAV | Where Publisher -ne 'Microsoft'
                
        foreach ($App in $Apps) {
            $App | Uninstall-NAVApp -DoNotSaveData
            $App | Sync-NAVApp -ServerInstance NAV -Mode Clean -force
            $App | UnPublish-NAVApp            
            Sync-NAVTenant -ServerInstance NAV -Tenant Default -Mode ForceSync -force    
        }                

    }
}