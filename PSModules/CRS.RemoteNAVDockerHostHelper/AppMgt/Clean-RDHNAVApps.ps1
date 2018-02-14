function Clean-RDHNAVApps {
    <#
    .SYNOPSIS
    Removes all non-Microsoft Apps from a Container on a remote Docker Host
    
    .DESCRIPTION
    Removes all non-Microsoft Apps from a Container on a remote Docker Host
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
            
    .PARAMETER ContainerName
    The Container
    
    .EXAMPLE
    Clean-RDHNAVApps `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $Containername 
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $DockerHost,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $DockerHostUseSSL,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.Remoting.PSSessionOption] $DockerHostSessionOption,
        [Parameter(Mandatory = $true)]
        [String] $ContainerName
    )

    Write-host "Removing all non-Microsoft Apps from Container $ContainerName on remote dockerhost $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        )
        
        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
       
            $Apps = Get-NAVAppInfo -ServerInstance NAV | Where Publisher -ne 'Microsoft'

            foreach ($App in $Apps){
                $App | Uninstall-NAVApp -DoNotSaveData
                $App | Sync-NAVApp -ServerInstance NAV -Mode Clean -force
                $App | UnPublish-NAVApp            
                Sync-NAVTenant -ServerInstance NAV -Tenant Default -Mode ForceSync -force    
                
                Write-Host "  Removed $($App.Name) from $($App.Publisher)" -ForegroundColor Gray
            }       
        }  
    }   -ArgumentList $ContainerName
}