function Copy-FileFromDockerHost {
    <#
    .SYNOPSIS
    Copies a file from the remote Docker Host to the local computer
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
        
    .PARAMETER RemotePath
    The remote filename that needs to be copied
    
    .PARAMETER LocalPath
    The folder where the file needs to end up on the local Computer
    
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
        [String] $RemotePath,
        [Parameter(Mandatory = $true)]
        [String] $LocalPath
    )
    
    Write-Host "Copying $RemotePath from Docker Host to local path: $LocalPath." -ForegroundColor Green

    $cs = New-PSSession -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption    
    Copy-Item -Path $RemotePath -Destination $LocalPath -FromSession $cs -Recurse
    Remove-PSSession -Session $cs
}