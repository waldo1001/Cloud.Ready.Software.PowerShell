function New-NAVContainerOnDockerHost {
    param(
        [Parameter(Mandatory = $true)]
        [String] $DockerHost,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $UseSSL,
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $ContainerIPAddress, 
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
    

    Invoke-Command -ComputerName $DockerHost -UseSSL:$UseSSL -Credential $DockerHostCredentials -ScriptBlock {
        param(
            $ContainerName, $ContainerIPAddress, $ContainerDockerImage, $ContainerLicenseFile, $ContainerMemory, [System.Management.Automation.PSCredential] $ContainerCredential, [bool] $ContainerAlwaysPull
        ) 

        New-NavContainer `
            -accept_eula `
            -containerName $ContainerName `
            -imageName $ContainerDockerImage `
            -licenseFile $ContainerLicenseFile `
            -doNotExportObjectsToText `
            -additionalParameters @("--network=tlan", "--ip $ContainerIPAddress") `
            -memoryLimit $ContainerMemory `
            -alwaysPull:$ContainerAlwaysPull `
            -updateHosts `
            -auth NavUserPassword `
            -includeCSide `
            -Verbose `
            -Credential $ContainerCredential 
    } -ArgumentList $ContainerName, $ContainerIPAddress, $ContainerDockerImage, $ContainerLicenseFile, $ContainerMemory, $ContainerCredential, $ContainerAlwaysPull

}