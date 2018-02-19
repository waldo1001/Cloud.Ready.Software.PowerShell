function Copy-FileToDockerHost {
    <#
    .SYNOPSIS
    Copies a file to a folder on the remote Docker Host - or any PSSession for that matter
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
    
    .PARAMETER RemotePath
    The folder where the file needs to end up on the remote Computer
    
    .PARAMETER LocalPath
    The local filename that needs to be copied
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
        [String] $RemotePath,
        [Parameter(Mandatory = $true)]
        [String] $LocalPath        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"
    Write-Host -ForegroundColor Green "Copying $LocalPath to Container $ContainerName on Docker Host $DockerHost" 

    #Zip
    if ([io.path]::GetExtension($LocalPath) -ne '.zip'){
        $ZippedFileName = "$LocalPath.zip"
        Write-Host "  Compressing $LocalPath..." -ForegroundColor Gray
        Compress-Archive -Path $LocalPath -DestinationPath $ZippedFileName -Force
    } else {
        $ZippedFileName = $LocalPath
    }
    
    #Create folder if not exists
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $RemotePath
        )
        
        #Create Folder if not exists
        If (!(Test-Path $RemotePath)){
            Write-Host -ForegroundColor Gray "  Creating folder $RemotePath on Docker Host"
            New-Item -Path $RemotePath -ItemType Directory -Force
        }

    } -ArgumentList $RemotePath -ErrorAction Stop

    #Copy
    $ZippedDestinationFileName = Join-Path $RemotePath (get-item $ZippedFileName).Name
    Write-Host "  Copying $ZippedFileName to $ZippedDestinationFileName on $DockerHost ..." -ForegroundColor Gray
    $cs = New-PSSession -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption    
    Copy-Item $ZippedFileName -Destination $ZippedDestinationFileName -ToSession $cs -Recurse

    #    $FileContent = get-content $ZippedFileName -Raw
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $RemotePath, $LocalPath, $ZippedDestinationFileName
        )
        
        #Unzip
        Write-Host "  Extracting $ZippedDestinationFileName..." -ForegroundColor Gray
        Unblock-File $ZippedDestinationFileName
        Expand-Archive $ZippedDestinationFileName $RemotePath -Force
        
        #Remove Zip
        Write-Host "  Removing $ZippedDestinationFileName..." -ForegroundColor Gray
        Remove-Item $ZippedDestinationFileName -Force

    } -ArgumentList $ContainerName, $RemotePath, (get-item $LocalPath).Name , $ZippedDestinationFileName
}