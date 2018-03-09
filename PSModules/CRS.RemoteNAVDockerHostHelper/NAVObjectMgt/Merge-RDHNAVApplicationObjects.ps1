function Merge-RDHNAVApplicationObjects {
    <#
    .SYNOPSIS
    Merge objects using a NAV Container on a remote Docker Host.
    
    .DESCRIPTION
    Just a wrapper for the "Merge-NCHNAVApplicationObjects" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).
    It is using the default merge commandlets coming from Microsoft, and the Cloud.Ready.Software.NAV module from waldo to merge objects.
    Things it considers/executes:
    - Merge the objects
    - Languages (avoid language conflicts by exporting and removing languages)
    - Merges version lists
    - Lists failed objects
    - Shows mergeresult
    - Saves mergeresult
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
    
    .PARAMETER ContainerName
    The Container used to merge
    
    .PARAMETER UpgradeSettings
    The is a dictionary - so a collection of settings.  See examples to see what settings there are, and how to create that dictionary.
    
    .EXAMPLE
    Creating the "UpgradeSettings" dictionary:
        #In one Dictionary, to be able to easily pass it to remote servers
        $UpgradeSettings = @{}

        #General
        $UpgradeSettings.UpgradeName = 'CustomerX'

        $UpgradeSettings.OriginalVersion = 'Distri81' 
        $UpgradeSettings.ModifiedVersion = 'CustomerX'
        $UpgradeSettings.TargetVersion = 'Distri110'

        $UpgradeSettings.LocalOriginalFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.OriginalVersion).zip"
        $UpgradeSettings.LocalModifiedFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.ModifiedVersion).zip"
        $UpgradeSettings.LocalTargetFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.TargetVersion).zip"

        $UpgradeSettings.VersionListPrefixes = 'NAVW1', 'NAVBE', 'I'
        $UpgradeSettings.AvoidConflictsForLanguages = 'NLB','FRB','ENU','ESP'

        #Semi-fixed settings (scope within container)
        $UpgradeSettings.UpgradeFolder = 'C:\ProgramData\NavContainerHelper\Upgrades' #locally in the container
        $UpgradeSettings.ObjectLibrary = Join-Path $UpgradeSettings.UpgradeFolder '_ObjectLibrary'
        $UpgradeSettings.ResultFolder = Join-Path $UpgradeSettings.UpgradeFolder "$($UpgradeSettings.UpgradeName)_Result"

        $UpgradeSettings.OriginalObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.OriginalVersion).txt"
        $UpgradeSettings.ModifiedObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.ModifiedVersion).txt"
        $UpgradeSettings.TargetObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.TargetVersion).txt"
    
    .EXAMPLE
    Perform upgrade:
        Merge-RDHNAVApplicationObjects `
            -DockerHost $DockerHost `
            -DockerHostCredentials $DockerHostCredentials `
            -ContainerName $ContainerName `
            -UpgradeSettings $UpgradeSettings

    .EXAMPLE
    A full example with collection of scripts for one upgrade can be found on my github: 
    https://github.com/waldo1001/Cloud.Ready.Software.PowerShell/tree/master/PSScripts/NAV%20Docker/RemoteDocker
    
    .NOTES
    This function is dependent from the Cloud.Ready.Software.* modules from waldo. Use the Install-RDHDependentModules to install the necessary modules on the remote servers/containers.
    
    #>
    param(        
        [Parameter(Mandatory = $true)]
        [String] $DockerHost,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $DockerHostUseSSL,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.Remoting.PSSessionOption] $DockerHostSessionOption,
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [Object] $UpgradeSettings
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $UpgradeSettings
        ) 

        Import-Module "CRS.NavContainerHelperExtension" -Force

        Merge-NCHNAVApplicationObjects `
            -ContainerName $ContainerName `
            -UpgradeSettings $UpgradeSettings
        
    } -ArgumentList $ContainerName, $UpgradeSettings
} 