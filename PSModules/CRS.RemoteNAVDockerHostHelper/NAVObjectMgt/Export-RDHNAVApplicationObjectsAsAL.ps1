function Export-RDHNAVApplicationObjectsAsAL {
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

    .PARAMETER extensionStartId
    default = 70000000
    the startId for extension objects - actually not used.
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
        [String] $Path,
        [Parameter(Mandatory = $false)]
        [int]$extensionStartId = 70000000
        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    if (-not (Test-Path $Path)) {
        $null = New-Item -Path $Path -ItemType Directory -Force
    }

    $resultfolder = Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $filter, $extensionStartId
        ) 

        Import-Module "CRS.NavContainerHelperExtension" -Force

        $resultfolder = Export-NCHNAVApplicationObjectsAsAL `
            -ContainerName $ContainerName `
            -filter $filter `
            -extensionStartId $extensionStartId
                
        return $resultfolder
    } -ArgumentList $ContainerName, $filter, $extensionStartId

    Copy-FileFromDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $resultfolder `
        -LocalPath $Path
}