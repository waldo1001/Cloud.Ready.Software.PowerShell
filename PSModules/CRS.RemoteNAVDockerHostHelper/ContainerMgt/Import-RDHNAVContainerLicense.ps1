function Import-RDHNAVContainerLicense {
    <#
    .SYNOPSIS
    Imports a license from a local PC, to a NAV Docker Container on a Remote Docker Host.
    
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

    .PARAMETER LicenseFile
    The license file that needs to be imported
    
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
        [String] $LicenseFile
    )

    $RemoteFolder = 'C:\ProgramData\navcontainerhelper'

    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $RemoteFolder `
        -LocalPath $LicenseFile 

    $RemoteLicenseFile = Join-Path $RemoteFolder (Get-item $LicenseFile).Name

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $containerName, $RemoteLicenseFile 
        )

        Import-NavContainerLicense -containerName $containerName -licenseFile $RemoteLicenseFile 
    
    } -ArgumentList $containerName, $RemoteLicenseFile 
    
}