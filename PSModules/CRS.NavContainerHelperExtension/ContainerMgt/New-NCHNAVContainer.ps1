function New-NCHNAVContainer {
    <#
    .SYNOPSIS
    Installs a new container using the navcontainerhelper module (from Freddy) on a docker host.
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ContainerName
    ContainerName
    
    .PARAMETER AdditionalParameters
    Additional Docker parameters
    
    .PARAMETER imageName
    The docker image

    .PARAMETER registryUserName
    Login username to login to the private registry that hosts the ContainerDockerImage
    
    .PARAMETER registryPwd
    Password to login to the private registry that hosts the ContainerDockerImage
    
    .PARAMETER LicenseFile
    The NAV License File
    
    .PARAMETER memoryLimit
    The memory the container is limited to use
    
    .PARAMETER Credential
    Credential for the container
    
    .PARAMETER alwaysPull
    Always pull a new version or not (switch)
        
    .PARAMETER DoNotInstallDependentModules
    Switch to avoid installing the Cloud.Ready.Software.* modules on the container

    .PARAMETER assignPremiumPlan
    Assigns premium plan in the sandbox

    .PARAMETER includeTestToolkit
    include Test Toolkit

    .PARAMETER includeTestLibrariesOnly
    include Test Libraries Only
    
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
        [String[]] $AdditionalParameters = @(), 
        [Parameter(Mandatory = $true)]
        [String] $imageName,        
        [Parameter(Mandatory = $false)]
        [String] $registryUserName, 
        [Parameter(Mandatory = $false)]
        [string] $registryPwd,         
        [Parameter(Mandatory = $true)]
        [String] $LicenseFile, 
        [Parameter(Mandatory = $false)]
        [String] $memoryLimit, 
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $Credential, 
        [Parameter(Mandatory = $false)]
        [Switch] $alwaysPull,
        [Parameter(Mandatory = $false)]
        [Switch] $accept_eula,
        [Parameter(Mandatory = $false)]
        [Switch] $DoNotInstallDependentModules,
        [Parameter(Mandatory = $false)]
        [Switch] $doNotExportObjectsToText,        
        [Parameter(Mandatory = $false)]
        [Switch] $enableSymbolLoading,
        [Parameter(Mandatory = $false)]
        [Switch] $includeTestToolkit,
        [Parameter(Mandatory = $false)]
        [Switch] $includeTestLibrariesOnly,
        [Parameter(Mandatory = $false)]
        [Switch] $assignPremiumPlan

    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    if ($registryUserName) {
        $registry = $imageName.Substring(0, $imageName.IndexOf('/'))
        Write-Host -ForegroundColor Gray "Connecting docker to $registry user: $registryUserName pwd: $registryPwd"
        docker login "$registry" -u "$registryUserName" -p "$registryPwd"
    }

    New-NavContainer `
        -accept_eula:$accept_eula `
        -containerName $ContainerName `
        -imageName $imageName `
        -licenseFile $LicenseFile `
        -memoryLimit $memoryLimit `
        -additionalParameters $AdditionalParameters `
        -alwaysPull:$alwaysPull `
        -Credential $Credential `
        -doNotExportObjectsToText:$doNotExportObjectsToText `
        -updateHosts `
        -auth NavUserPassword `
        -includeCSide `
        -enableSymbolLoading:$enableSymbolLoading `
        -assignPremiumPlan:$assignPremiumPlan `
        -useBestContainerOS `
        -includeTestToolkit:$includeTestToolkit `
        -includeTestLibrariesOnly:$includeTestLibrariesOnly `
        -Verbose

    if (!$DoNotInstallDependentModules) {
        Install-NCHDependentModules `
            -ContainerName $ContainerName `
            -ContainerModulesOnly
    }

    Sync-NCHNAVTenant -containerName $ContainerName
}