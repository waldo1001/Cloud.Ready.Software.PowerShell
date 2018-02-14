. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'devpreview'
$Appfilename = 'C:\Users\Waldo\Dropbox\Cloud Ready Software\Projects\Microsoft\HDI Videos\waldo\HDI add upgrade logic to an extension\Apps\Books\Cloud Ready Software GmbH_BookShelf_1.0.0.0.app'

Upgrade-RDHNAVApp `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -AppFileName $Appfilename `
    -Verbose