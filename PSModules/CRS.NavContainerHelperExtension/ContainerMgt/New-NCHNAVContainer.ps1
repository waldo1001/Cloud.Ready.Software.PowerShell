function New-NCHNAVContainer {
    <#
    .SYNOPSIS
    Installs a new container using the navcontainerhelper module (from Freddy) on a docker host.
    
    .DESCRIPTION
    Long description
    
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
        
    .PARAMETER DoNotInstallDependentModules
    Switch to avoid installing the Cloud.Ready.Software.* modules on the container
    
    .EXAMPLE
    Simply create a new container:

    New-NCHNAVContainer `
        -ContainerDockerImage $ContainerDockerImage `
        -ContainerName $Containername `
        -ContainerLicenseFile $ContainerLicenseFile `
        -ContainerCredential $ContainerCredential `
        -ContainerAlwaysPull `
        -ContainerAdditionalParameters $ContainerAdditionalParameters
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [String[]] $AdditionalParameters=@(), 
        [Parameter(Mandatory = $true)]
        [String] $imageName, 
        [Parameter(Mandatory = $true)]
        [String] $LicenseFile, 
        [Parameter(Mandatory = $false)]
        [String] $memoryLimit = '3G', 
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $Credential, 
        [Parameter(Mandatory = $true)]
        [Switch] $alwaysPull,
        [Parameter(Mandatory = $false)]
        [Switch] $accept_eula,
        [Parameter(Mandatory = $false)]
        [Switch] $DoNotInstallDependentModules,
        [Parameter(Mandatory = $false)]
        [Switch] $doNotExportObjectsToText
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    New-NavContainer `
        -accept_eula:$accept_eula `
        -containerName $ContainerName `
        -imageName $imageName `
        -licenseFile $LicenseFile `
        -additionalParameters $AdditionalParameters `
        -memoryLimit $memoryLimit `
        -alwaysPull:$alwaysPull `
        -Credential $Credential `
        -doNotExportObjectsToText:$doNotExportObjectsToText `
        -updateHosts `
        -auth NavUserPassword `
        -includeCSide `
        -Verbose 

    if (!$DoNotInstallDependentModules){
        Install-NCHDependentModules `
            -ContainerName $ContainerName `
            -ContainerModulesOnly
    }

    Sync-NCHNAVTenant -containerName $ContainerName
}