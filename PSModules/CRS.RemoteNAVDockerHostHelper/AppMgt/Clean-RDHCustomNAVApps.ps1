function Clean-RDHCustomNAVApps {
    <#
    .SYNOPSIS
    Removes all non-Microsoft Apps from a Container on a remote Docker Host
    
    .DESCRIPTION
    Just a wrapper for the "Clean-NCHCustomNAVApps" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).
    
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
    Clean-RDHCustomNAVApps `
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

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"
    
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        )
        
        Import-Module "CRS.NavContainerHelperExtension" -Force

        Clean-NCHCustomNAVApps -ContainerName $ContainerName

    }   -ArgumentList $ContainerName
}