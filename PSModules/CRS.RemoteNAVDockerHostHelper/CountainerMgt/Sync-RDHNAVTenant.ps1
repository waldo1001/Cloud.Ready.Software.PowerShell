function Sync-RDHNAVTenant {
    <#
    .SYNOPSIS
    Execute Sync-NAVTenant on a container that's running on a remote docker host.
    
    .DESCRIPTION
    Execute Sync-NAVTenant on a container that's running on a remote docker host.
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
    
    .PARAMETER ContainerName
    The container you want to run this function on
    
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
    
    Write-Host "Running 'Sync-NAVTenant -Force' on Container $ContainerName on Remote Docker Host $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        ) 

        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
            Sync-NAVTenant -ServerInstance NAV -Force
        }

    } -ArgumentList $ContainerName

}