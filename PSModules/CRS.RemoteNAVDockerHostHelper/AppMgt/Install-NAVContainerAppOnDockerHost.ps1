function Install-NAVContainerAppOnDockerHost {
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
        [String] $AppFileName
    )

    $LocalAppPath = 
        Copy-NAVAppToDockerHost `
            -DockerHost $DockerHost `
            -DockerHostCredentials $DockerHostCredentials `
            -ContainerName $DockerContainer `
            -UseSSL:$UseSSL `
            -AppFileName $AppFileName

    Invoke-Command -ComputerName $DockerHost -UseSSL:$UseSSL -Credential $DockerHostCredentials -ScriptBlock {
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

        }   -ArgumentList $LocalAppPath
    }   -ArgumentList $ContainerName, $LocalAppPath

}