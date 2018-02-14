function Install-RDHDependentModules {
    <#
    .SYNOPSIS
    Installs waldo's modules on the container
    
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
        [String] $ContainerName
    )

    Write-host "Installing dependent modules on DockerHost $DockerHost" -ForegroundColor Green

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        ) 

        $FindModule = Find-Module 'navcontainerhelper'
        write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) on Docker Host." -ForegroundColor Gray
        Install-Module 'navcontainerhelper' -Force 

        if ($ContainerName){
            $Session = Get-NavContainerSession -containerName $ContainerName
            Invoke-Command -Session $Session -ScriptBlock {
                param(
                    $ContainerName
                )
                function InstallModuleFromPSGallery ([String] $Module) {
                    $FindModule = Find-Module $Module
                    write-host -Object "  Installing $($FindModule.Name) version $($FindModule.Version) from $($FindModule.Repository) on Container $ContainerName" -ForegroundColor Gray
                    Install-Module $Module -Force 
                }

                Write-host "Installing dependent modules on Container $ContainerName" -ForegroundColor Green

                InstallModuleFromPSGallery -Module Cloud.Ready.Software.NAV 
                InstallModuleFromPSGallery -Module Cloud.Ready.Software.SQL 
                InstallModuleFromPSGallery -Module Cloud.Ready.Software.Windows 
                InstallModuleFromPSGallery -Module Cloud.Ready.Software.PowerShell 
            } -ArgumentList $ContainerName
        }
    } -ArgumentList $ContainerName
}