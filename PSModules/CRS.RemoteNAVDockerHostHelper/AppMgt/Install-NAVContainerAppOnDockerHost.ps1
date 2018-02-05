function Install-NAVContainerAppOnDockerHost {
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

    $LocalAppPath = 
    Copy-NAVAppToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $ContainerName `
        -AppFileName $AppFileName `
        -ErrorAction Stop

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

            if (-not $DoNotDeleteAppFile) {
                Remove-Item -Path $LocalAppPath -Force
            }
        }   -ArgumentList $LocalAppPath
    }   -ArgumentList $ContainerName, $LocalAppPath

}