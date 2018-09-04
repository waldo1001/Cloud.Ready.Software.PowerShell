. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$AppFile = "C:\Users\ericw\Dropbox (Personal)\GitHub\MostUselessAppEver\waldo_Most Useless App Ever_1.0.0.7.app"
#$AppFile = "C:\Users\ericw\Dropbox (Personal)\GitHub\MostUselessDependencyEver\waldo_Most Useless Dependency App Ever_2.0.0.0.app"

$Containername = 'devpreview'

Upgrade-RDHNAVApp `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -AppFileName $AppFile 