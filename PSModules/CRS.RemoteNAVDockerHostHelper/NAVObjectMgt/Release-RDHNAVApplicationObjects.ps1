function Release-RDHNAVApplicationObjects {
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
        [Object] $ReleaseSettings        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    $LocalFile = Get-Item $ReleaseSettings.LocalPath -ErrorAction Stop
    if ([String]::IsNullOrEmpty($ReleaseSettings.ContainerPath)) {
        $ReleaseSettings.ContainerPath = "C:\ProgramData\NavContainerHelper\ReleaseProduct\$($ReleaseSettings.Product)_$($ReleaseSettings.ProductVersion.Replace('.',''))"
    }

    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $ReleaseSettings.ContainerPath `
        -LocalPath $ReleaseSettings.LocalPath
        
    $ReleaseSettings.ContainerPath = (Join-Path $ReleaseSettings.ContainerPath $LocalFile.Name)
    
    [Object] $ReleaseResult = 
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $ReleaseSettings
        ) 

        Import-Module "CRS.NavContainerHelperExtension" -Force        

        Release-NCHNAVApplicationObjects `
            -ContainerName $ContainerName `
            -ReleaseSettings $ReleaseSettings
            
    } -ArgumentList $ContainerName, $ReleaseSettings
    
    $ReleaseResult.LocalPath = (Join-Path (Get-Item $ReleaseSettings.LocalPath).Directory "$((Get-Item $ReleaseSettings.LocalPath).BaseName).Released.txt")
    Copy-FileFromDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -RemotePath $ReleaseResult.ContainerFilePath `
        -LocalPath  $ReleaseResult.LocalPath 

    return $ReleaseResult
}