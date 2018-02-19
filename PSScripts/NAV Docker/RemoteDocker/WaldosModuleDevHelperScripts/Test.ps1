. (Join-Path $PSScriptRoot '.\_Settings.ps1')


#Tests

$Containername = 'psdevenv'
$Appfilename = "$env:USERPROFILE\Dropbox\Cloud Ready Software\Projects\Microsoft\HDI Videos\waldo\HDI add upgrade logic to an extension\Apps\Books\Cloud Ready Software GmbH_BookShelf_1.0.0.0.app"

Upgrade-RDHNAVApp `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -AppFileName $Appfilename `
    -Verbose

break

$Containername = 'psdevenv'
$Appfilename = "$env:USERPROFILE\Dropbox\Cloud Ready Software\Projects\Microsoft\HDI Videos\waldo\HDI add upgrade logic to an extension\Apps\Books\Cloud Ready Software GmbH_BookShelf_1.0.0.0.app"
 Install-RDHNAVApp `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -AppFileName $Appfilename `
    -Verbose

break

get-rdhCustomNAVApps `        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName psdevenv
breakClean-RDHCustomNAVApps `        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName psdevenv

break
    New-RDHNAVSuperUser `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $Containername `
        -Username 'waldo2' `
        -Password (ConvertTo-SecureString 'waldo1234' -AsPlainText -Force) `
        -CreateWebServicesKey
break

Remove-RDHNAVContainer -ContainerName psdevenv `    -DockerHost $DockerHost `    -DockerHostCredentials $DockerHostCredentials `    -DockerHostUseSSL:$DockerHostUseSSL `    -DockerHostSessionOption $DockerHostSessionOption `
break

Install-RDHDependentModules `
    -DockerHost $DockerHost `    -DockerHostCredentials $DockerHostCredentials `    -DockerHostUseSSL:$DockerHostUseSSL `    -DockerHostSessionOption $DockerHostSessionOption `Sync-RDHNAVTenant `    -DockerHost $DockerHost `    -DockerHostCredentials $DockerHostCredentials `    -DockerHostUseSSL:$DockerHostUseSSL `    -DockerHostSessionOption $DockerHostSessionOption `    -ContainerName devpreview