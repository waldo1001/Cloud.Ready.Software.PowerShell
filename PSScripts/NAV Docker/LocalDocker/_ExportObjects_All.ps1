. (Join-Path $PSScriptRoot '.\_Settings.ps1')

break #TODO

$ObjectsFolder = "C:\temp"
#$ContainerDockerImage = 'microsoft/bcsandbox:us'
$ContainerDockerImage = 'microsoft/dynamics-nav:2018-cu8'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox'

#Fixed params
$ExportToBase = "$env:USERPROFILE\Dropbox (Personal)\Dynamics NAV\ObjectLibrary\"
switch ($true) {
    ($ContainerDockerImage.StartsWith('microsoft/bcsandbox')) {  
        $ExportTo = join-path $ExportToBase 'Business Central (Current)'
        break
    }  
    ($ContainerDockerImage.StartsWith('bcinsider.azurecr.io/bcsandbox-master')) {  
        $ExportTo = join-path $ExportToBase 'Business Central (Insider Daily Build)'
        break
    }  
    ($ContainerDockerImage.StartsWith('bcinsider.azurecr.io/bcsandbox')) {  
        $ExportTo = join-path $ExportToBase 'Business Central (Insider Next)'
        break
    }
    ($ContainerDockerImage.Contains('2018')) {  
        $ExportTo = join-path $ExportToBase 'NAV2018'
        break
    }
    ($ContainerDockerImage.StartsWith('2017')) {  
        $ExportTo = join-path $ExportToBase 'NAV2017'
        break
    }

}

$ModuleToolAPIPath = "$env:USERPROFILE\Dropbox\GitHub\Waldo.Model.Tools\ReVision.Model.Tools Library - laptop"

$Containername = 'temponly'
$ContainerAdditionalParameters += "--ip 172.21.31.13"
$ContainerAlwaysPull = $true

New-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerDockerImage $ContainerDockerImage `
    -ContainerName $Containername `
    -ContainerLicenseFile $SecretSettings.containerLicenseFile `
    -ContainerCredential $ContainerCredential `
    -ContainerAlwaysPull:$ContainerAlwaysPull `
    -ContainerAdditionalParameters $ContainerAdditionalParameters `
    -doNotExportObjectsToText 

$ObjectFile = 
Export-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Path $ObjectsFolder

Remove-RDHNAVContainer `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername 
