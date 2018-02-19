function Install-RDHNAVApp {
    <#
    .SYNOPSIS
    Installs App on a NAV Container on a remote Docker Host.
    
    .DESCRIPTION
    Just a wrapper for the "Install-NCHNavApp" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).

    Before installing the app on the NAV ServerInstance of a Container on a remote Docker Host, the function will copy the local AppFile to the remote Docker Host.
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
        
    .PARAMETER ContainerName
    ContainerName
    
    .PARAMETER AppFileName
    The path to the local .app-file
        
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
        [Parameter(Mandatory = $true)]
        [String] $AppFileName
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"
    
    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath "C:\ProgramData\navcontainerhelper\Apps" `
        -LocalPath $AppFileName `
        -ErrorAction Stop
    
    $LocalAppPath = Join-Path "C:\ProgramData\navcontainerhelper\Apps" (get-item $AppFileName).Name
    
    Write-host "Installing App $AppFileName on $ContainerName on remote dockerhost $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $LocalAppPath
        )

        Import-Module "CRS.NavContainerHelperExtension" -Force

        Install-NCHNavApp `
            -ContainerName $ContainerName `
            -Path $LocalAppPath

    }   -ArgumentList $ContainerName, $LocalAppPath

}