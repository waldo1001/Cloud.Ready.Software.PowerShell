function New-RDHNAVContainer {
    <#
    .SYNOPSIS
    Installs a new container using the navcontainerhelper module (from Freddy) on a remote docker host.
            
    .DESCRIPTION
    Just a wrapper for the "New-NCHNAVContainer" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).

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
    
    .PARAMETER ContainerAdditionalParameters
    Additional Docker parameters
    
    .PARAMETER ContainerDockerImage
    The docker image
    
    .PARAMETER ContainerRegistryUserName
    Login username to login to the private registry that hosts the ContainerDockerImage

    .PARAMETER ContainerRegistryPwd
    Password to login to the private registry that hosts the ContainerDockerImage

    .PARAMETER ContainerLicenseFile
    The NAV License File
    
    .PARAMETER ContainerMemory
    The memory the container is limited to use (Default: 3G)
    
    .PARAMETER ContainerCredential
    Credential for the container
    
    .PARAMETER ContainerAlwaysPull
    Always pull a new version or not (switch)
    
    .EXAMPLE
    New-RDHNAVContainer `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDockerImage $ContainerDockerImage `
        -ContainerName $Containername `
        -ContainerLicenseFile $ContainerLicenseFile `
        -ContainerCredential $ContainerCredential `
        -ContainerAlwaysPull `
        -ContainerAdditionalParameters $ContainerAdditionalParameters
    
    
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
        [String[]] $ContainerAdditionalParameters = @(), 
        [Parameter(Mandatory = $true)]
        [String] $ContainerDockerImage, 
        [Parameter(Mandatory = $false)]
        [String] $ContainerRegistryUserName, 
        [Parameter(Mandatory = $false)]
        [String] $ContainerRegistryPwd,         
        [Parameter(Mandatory = $true)]
        [String] $ContainerLicenseFile, 
        [Parameter(Mandatory = $false)]
        [String] $ContainerMemory, 
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $ContainerCredential, 
        [Parameter(Mandatory = $false)]
        [Switch] $ContainerAlwaysPull,
        [Parameter(Mandatory = $false)]
        [Switch] $DoNotInstallDependentModules,
        [Parameter(Mandatory = $false)]
        [Switch] $doNotExportObjectsToText
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $ContainerAdditionalParameters, $ContainerDockerImage, $ContainerRegistryUserName, $ContainerRegistryPwd, $ContainerLicenseFile, $ContainerMemory, [System.Management.Automation.PSCredential] $ContainerCredential, [bool] $ContainerAlwaysPull, $DoNotInstallDependentModules, $doNotExportObjectsToText
        ) 

        Import-Module "CRS.NavContainerHelperExtension" -Force
        
        New-NCHNAVContainer `
            -containerName $ContainerName `
            -additionalParameters $ContainerAdditionalParameters `
            -imageName $ContainerDockerImage `
            -registryUserName $ContainerRegistryUserName `
            -registryPwd $ContainerRegistryPwd `
            -licenseFile $ContainerLicenseFile `
            -memoryLimit $ContainerMemory `
            -Credential $ContainerCredential `
            -alwaysPull:$ContainerAlwaysPull `
            -doNotExportObjectsToText:$doNotExportObjectsToText `
            -accept_eula `
            -DoNotInstallDependentModules:$DoNotInstallDependentModules

    } -ArgumentList $ContainerName, $ContainerAdditionalParameters, $ContainerDockerImage, $ContainerRegistryUserName, $ContainerRegistryPwd, $ContainerLicenseFile, $ContainerMemory, $ContainerCredential, $ContainerAlwaysPull, $DoNotInstallDependentModules, $doNotExportObjectsToText
}