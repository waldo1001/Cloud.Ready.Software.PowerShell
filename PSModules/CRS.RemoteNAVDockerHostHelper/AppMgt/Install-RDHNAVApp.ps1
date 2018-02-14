function Install-RDHNAVApp {
    <#
    .SYNOPSIS
    Installs App on a NAV Container on a remote Docker Host.
    
    .DESCRIPTION
    Before installing the app on the NAV ServerInstance of a Container on a remote Docker Host, the function will copy the local AppFile to the remote Docker Host.
    
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
    
    .PARAMETER AppFileName
    The path to the local .app-file
    
    .PARAMETER DoNotDeleteAppFile
    Will not delete the AppFile from the RemoteDockerHost.
    
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
        [String] $AppFileName,
        [Parameter(Mandatory = $false)]
        [Switch] $DoNotDeleteAppFile
    )

    Write-host "Installing App $AppFileName on $ContainerName on remote dockerhost $DockerHost" -ForegroundColor Green

    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDestinationFolder "C:\ProgramData\navcontainerhelper\" `
        -FileName $AppFileName `
        -ErrorAction Stop

    $LocalAppPath = "C:\ProgramData\navcontainerhelper\" + (get-item $AppFileName).Name

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $LocalAppPath
        )
        
        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
            param(
                $LocalAppPath
            )
        
            $App = Get-NAVAppInfo -Path $LocalAppPath
            
            Get-NAVAppInfo -ServerInstance NAV -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
            Uninstall-NAVApp
            
            Get-NAVAppInfo -ServerInstance NAV -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
            Unpublish-NAVApp
            
            Publish-NAVApp `
            -ServerInstance NAV `
            -Path $LocalAppPath `
            -SkipVerification
            
            Sync-NAVApp `
            -ServerInstance NAV `
            -Name $App.Name `
            -Publisher $App.Publisher `
            -Version $App.Version
            
            Install-navapp `
            -ServerInstance NAV `
            -Name $App.Name `
            -Publisher $App.Publisher `
            -Version $App.Version                
            
            Write-host "  Installed $($App.Name) from $($App.Publisher)" -ForegroundColor Gray
            
            if (-not $DoNotDeleteAppFile) {
                Remove-Item -Path $LocalAppPath -Force
            }
        }   -ArgumentList $LocalAppPath
    }   -ArgumentList $ContainerName, $LocalAppPath

}