
. '.\_Settings.ps1'

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDestinationFolder $UpgradeSettings.ObjectLibrary `
        -FileName $UpgradeSettings.LocalOriginalFile

$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDestinationFolder $UpgradeSettings.ObjectLibrary `
        -FileName $UpgradeSettings.LocalTargetFile
        
$Filename = 
    Copy-FileToDockerHost `
        -DockerHost $Dockerhost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDestinationFolder $UpgradeSettings.ObjectLibrary `
        -FileName "C:\temp\VARO2013R2.txt"
        
        

$Filename.FullName