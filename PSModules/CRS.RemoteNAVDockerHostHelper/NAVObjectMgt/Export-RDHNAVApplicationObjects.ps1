function Export-RDHNAVApplicationObjects {
    <#
    .SYNOPSIS
    Exports objects from an NAV (Business Central) database, on a Docker image on a Docker Host, and copies it all the way to your own PC.
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
    
    .PARAMETER ContainerName
    The containername from where it should export the objects

    .PARAMETER Filter
    The object filter
    
    .PARAMETER Path
    The local filename that needs to be copied
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
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [String] $filter,
        [Parameter(Mandatory = $true)]
        [String] $Path
        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    $result = Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $filter, $result
        ) 

        Import-Module "CRS.NavContainerHelperExtension" -Force

        $result = Export-NCHNAVApplicationObjects `
            -ContainerName $ContainerName `
            -filter $filter
                
        return $result
    } -ArgumentList $ContainerName, $filter, $result

    Copy-FileFromDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $result `
        -LocalPath $Path
}