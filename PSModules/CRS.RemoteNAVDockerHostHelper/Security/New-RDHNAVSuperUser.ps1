function New-RDHNAVSuperUser {
    <#
    .SYNOPSIS
    Create a super user on a NAVContainer on a Remote Docker Host
    
    .DESCRIPTION
    Just a wrapper for the "New-NCHNAVSuperUser" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).

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
    
    .PARAMETER Username
    The Username
    
    .PARAMETER Password
    The password (will be converted to secure string)
    
    .PARAMETER CreateWebServicesKey
    Switch to create a webserviceskey on the way..
    
    .EXAMPLE
    Create a new user "waldo2"
    
    New-RDHNAVSuperUser `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $Containername `
        -Username 'waldo2' `
        -Password (ConvertTo-SecureString 'waldo1234' -AsPlainText -Force) `
        -CreateWebServicesKey
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String] $DockerHost,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $DockerHostUseSSL,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.Remoting.PSSessionOption] $DockerHostSessionOption,
        [Parameter(Mandatory=$true)]
        [String] $ContainerName,
        [Parameter(Mandatory=$true)]
        [String] $Username,
        [Parameter(Mandatory=$true)]
        [SecureString] $Password,
        [Parameter(Mandatory=$false)]
        [switch] $CreateWebServicesKey        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName,$CreateWebServicesKey,$Username,[SecureString] $Password
        )
        
        Import-Module "CRS.NavContainerHelperExtension" -Force

        New-NCHNAVSuperUser `
            -ContainerName $ContainerName `
            -Username $Username `
            -Password $Password `
            -CreateWebServicesKey:$CreateWebServicesKey
                
    }  -ArgumentList  $ContainerName,$CreateWebServicesKey,$Username,$Password
}

