function Sync-NAVContainerTenantOnDockerHost {
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
        [String] $ContainerName
    )
    

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName
        ) 

        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
            param(
                $LocalAppPath
            )

            Sync-NAVTenant -ServerInstance nav -Force

        } -ArgumentList $ContainerName

    } -ArgumentList $ContainerName

}