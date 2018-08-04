function Import-RDHTestToolkitToNavContainer {
    <#
    .SYNOPSIS
    Imports the Test Toolkit with the navcontainerhelper - but from a remote host.
    
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

    .PARAMETER ContainerSqlCredential
    The SQL Credentials for the database on docker.  Usually username is "sa", and password is the one you set up as the NAV Docker User.
    
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
        [System.Management.Automation.PSCredential] $ContainerSqlCredential

    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, [System.Management.Automation.PSCredential] $ContainerSqlCredential
        ) 

        Import-Module "navcontainerhelper" -Force
        
        Import-TestToolkitToNavContainer `
            -containerName $Containername `
            -sqlCredential $ContainerSqlCredential

    } -ArgumentList $ContainerName, $ContainerSqlCredential
}