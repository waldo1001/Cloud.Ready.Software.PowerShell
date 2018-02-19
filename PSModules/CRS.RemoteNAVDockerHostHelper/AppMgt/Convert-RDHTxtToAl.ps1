function Convert-RDHTxtToAl {
    <#
    .SYNOPSIS
    Converts txt to al on a remote dockerhost.
    
    .DESCRIPTION
    Just a wrapper for the "Convert-NCHTxtToAl" (Module "CRS.NavContainerHelperExtension" that should be installed on the Docker Host).
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
            
    .PARAMETER ContainerName
    The Container
    
    .PARAMETER TxtFile
    Path to the txt-file that needs to be converted
    
    .PARAMETER sqlCredential
    SQL credential to be able to use the finsql
    
    .PARAMETER startId
    The startID for extension objects
    
    .PARAMETER objectsFilter
    The object filter that would identify all objects
    
    .PARAMETER LocalResultFolder
    The resultfolder to copy the result to
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $DockerHost,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $DockerHostUseSSL,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.Remoting.PSSessionOption] $DockerHostSessionOption,
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $TxtFile,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $sqlCredential,
        [Parameter(Mandatory = $false)]
        [int] $startId = 50000,
        [Parameter(Mandatory = $false)]
        [String] $objectsFilter = '',
        [Parameter(Mandatory = $true)]
        [String] $LocalResultFolder
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath "C:\ProgramData\navcontainerhelper\ConvertTxt2Al" `
        -LocalPath $TxtFile `
        -ErrorAction Stop
    
    $LocalTxtFile = Join-Path "C:\ProgramData\navcontainerhelper\ConvertTxt2Al" (get-item $TxtFile).Name

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $LocalTxtFile, $sqlCredential, $startId, $objectsFilter
        )

        Import-Module "CRS.NavContainerHelperExtension" -Force

        Convert-NCHTxtToAl `
            -ComputerName $ContainerName `
            -TxtFile LocalTxtFile`
            -sqlCredential $sqlCredential ´
            -startId $StartId `
            -objectFilter $objectsFilter 

    }   -ArgumentList $ContainerName, $LocalTxtFile, $sqlCredential, $startId, $objectsFilter

    Copy-FileFromDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath "C:\ProgramData\navcontainerhelper\ConvertTxt2Al\Al.zip" `
        -LocalPath "$LocalResultFolder.zip"

    Get-Item -Path $LocalResultFolder
}