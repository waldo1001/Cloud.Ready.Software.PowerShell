. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'RBA'
$Appfilename = "C:\Users\Waldo\Documents\My Received Files\Cloud Ready Software GmbH_ReceiptBank_1.0.1.1\Cloud Ready Software GmbH_ReceiptBank_1.0.1.1.app"

Install-RDHNAVApp `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -AppFileName $Appfilename `
    -Verbose

Get-RDHCustomNAVApps `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername 
