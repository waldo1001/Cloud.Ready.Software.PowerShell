function Get-RDHCustomNAVApps {
    <#
    .SYNOPSIS
    Gets all non-Microsoft Apps from a Container on a remote Docker Host
    
    .DESCRIPTION
    Gets all non-Microsoft Apps from a Container on a remote Docker Host
    
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
    Get-RDHCustomNAVApps `
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

    Write-host "Getting all non-Microsoft Apps from Container $ContainerName on remote dockerhost $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        )
        
        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
       
            Return Get-NAVAppInfo -ServerInstance NAV | Where Publisher -ne 'Microsoft'
 
        }  
    }   -ArgumentList $ContainerName
}