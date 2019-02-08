
. '.\_Settings.ps1'

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath $UpgradeSettings.LocalOriginalFile
        
$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath $UpgradeSettings.LocalModifiedFile

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath $UpgradeSettings.LocalTargetFile
        
        

$Filename.FullName