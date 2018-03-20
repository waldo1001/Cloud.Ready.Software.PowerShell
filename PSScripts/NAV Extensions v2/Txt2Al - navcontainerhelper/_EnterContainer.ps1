<#
NOT used for the video - only to make my (waldo) life easier during development of the scripts
#>

. (Join-Path $PSScriptRoot '.\_Settings.ps1')

if (-not($DockerHostSession)){
    $DockerHostSession = New-PSSession -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption
}
Enter-PSSession -Session $DockerHostSession 

break

Enter-NavContainer -containerName 'devpreview'