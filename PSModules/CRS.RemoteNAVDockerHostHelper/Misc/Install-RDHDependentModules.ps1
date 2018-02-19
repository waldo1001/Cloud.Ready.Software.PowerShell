function Install-RDHDependentModules {
    <#
    .SYNOPSIS
    Installs waldo's modules on the container

    .DESCRIPTION
    Just a wrapper for the "Install-NCHDependentModules" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).
    
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
    
    .EXAMPLE
    Install-RDHDependentModules `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $DockerContainerName
    
    .NOTES
    DockerHost should have module "CRS.NavContainerHelperExtension" installed.  
    Prep the DockerHost simply by running "Install-RDHDependentModules"

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
        [Parameter(Mandatory = $false)]
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [Switch] $ContainerModulesOnly
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $ContainerModulesOnly
        ) 

        if (!$ContainerModulesOnly) {
            $null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            
            #navcontainerhelper
            $FindModule = Find-Module 'navcontainerhelper'            
            if($FindModule){
                write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
                Install-Module 'navcontainerhelper' -Force 
            }
            
            #CRS.NavContainerHelperExtension
            $FindModule = Find-Module 'CRS.NavContainerHelperExtension'           
            if($FindModule){
                write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
                Install-Module 'CRS.NavContainerHelperExtension' -Force 
            }
        }
        
        Import-Module "CRS.NavContainerHelperExtension" -Force
        Install-NCHDependentModules -ContainerName $ContainerName -ContainerModulesOnly
        
    } -ArgumentList $ContainerName, $ContainerModulesOnly
}