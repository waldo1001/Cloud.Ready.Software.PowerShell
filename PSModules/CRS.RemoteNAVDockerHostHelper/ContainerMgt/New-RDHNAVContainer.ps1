function New-RDHNAVContainer {
    <#
    .SYNOPSIS
    Installs a new container using the navcontainerhelper module (from Freddy) on a remote docker host.
        
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
        [String[]] $ContainerAdditionalParameters=@(), 
        [Parameter(Mandatory = $true)]
        [String] $ContainerDockerImage, 
        [Parameter(Mandatory = $true)]
        [String] $ContainerLicenseFile, 
        [Parameter(Mandatory = $false)]
        [String] $ContainerMemory = '3G', 
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $ContainerCredential, 
        [Parameter(Mandatory = $true)]
        [switch] $ContainerAlwaysPull
    )
    Write-host "Installing Container $ContainerName from image $ContainerDockerImage on remote dockerhost $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $ContainerAdditionalParameters, $ContainerDockerImage, $ContainerLicenseFile, $ContainerMemory, [System.Management.Automation.PSCredential] $ContainerCredential, [bool] $ContainerAlwaysPull
        ) 

        New-NavContainer `
            -accept_eula `
            -containerName $ContainerName `
            -imageName $ContainerDockerImage `
            -licenseFile $ContainerLicenseFile `
            -doNotExportObjectsToText `
            -additionalParameters $ContainerAdditionalParameters `
            -memoryLimit $ContainerMemory `
            -alwaysPull:$ContainerAlwaysPull `
            -updateHosts `
            -auth NavUserPassword `
            -includeCSide `
            -Verbose `
            -Credential $ContainerCredential 
    } -ArgumentList $ContainerName, $ContainerAdditionalParameters, $ContainerDockerImage, $ContainerLicenseFile, $ContainerMemory, $ContainerCredential, $ContainerAlwaysPull

}