
. '.\_Settings.ps1'

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath $UpgradeSettings.LocalOriginalFile

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath $UpgradeSettings.LocalTargetFile
        
$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $UpgradeSettings.ObjectLibrary `
        -LocalPath "C:\temp\VARO2013R2.txt"
        
        

$Filename.FullName