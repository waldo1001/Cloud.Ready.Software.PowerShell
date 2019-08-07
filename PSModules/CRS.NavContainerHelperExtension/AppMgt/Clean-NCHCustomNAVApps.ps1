function Clean-NCHCustomNAVApps {
    <#
    .SYNOPSIS
    Removes all non-Microsoft Apps from a Container
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ContainerName
    The Container
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        $SC = Get-NAVServerInstance

        $Apps = Get-NAVAppInfo -ServerInstance $SC.ServerInstance | Where Publisher -ne 'Microsoft'

        foreach ($App in $Apps) {
            $App | Uninstall-NAVApp -DoNotSaveData
            $App | Sync-NAVApp -ServerInstance $SC.ServerInstance -Mode Clean -force
            $App | UnPublish-NAVApp            
            Sync-NAVTenant -ServerInstance NAV -Tenant Default -Mode ForceSync -force    
            
            Write-Host "  Removed $($App.Name) from $($App.Publisher)" -ForegroundColor Gray
        }       
    }  

}