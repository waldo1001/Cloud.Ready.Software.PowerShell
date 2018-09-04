<#
join the dockerhost first, before you will execute the steps
#>

. (Join-Path $PSScriptRoot '.\_Settings.ps1')

if (-not($DockerHostSession)) {
    $DockerHostSession = New-PSSession -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption
}
Enter-PSSession -Session $DockerHostSession 

break

Enter-NavContainer -containerName 'tempdev'