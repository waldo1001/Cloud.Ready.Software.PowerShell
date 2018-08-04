function Copy-FileFromDockerHost {
    <#
    .SYNOPSIS
    Copies a file from the remote Docker Host to the local computer
    
    .PARAMETER DockerHost
    The DockerHost VM name to reach the server that runs docker and hosts the container
    
    .PARAMETER DockerHostCredentials
    The credentials to log into your docker host
    
    .PARAMETER DockerHostUseSSL
    Switch: use SSL or not
    
    .PARAMETER DockerHostSessionOption
    SessionOptions if necessary
        
    .PARAMETER RemotePath
    The remote filename that needs to be copied
    
    .PARAMETER LocalPath
    The folder where the file needs to end up on the local Computer
    
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
    Write-Host -ForegroundColor Green "Copying $RemotePath from Docker Host to local path: $LocalPath." 

    #Zip
    $ZippedFileName = Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $RemotePath
        )

        if ([io.path]::GetExtension($RemotePath) -ne '.zip') {
            $ZippedFileName = "$RemotePath.zip"
            Write-Host "  Compressing $RemotePath..." -ForegroundColor Gray
            Compress-Archive -Path $RemotePath -DestinationPath $ZippedFileName -Force
        }
        else {
            $ZippedFileName = $RemotePath
        }

        return (get-item $ZippedFileName)
    } -ArgumentList $RemotePath -ErrorAction Stop

    #Copy
    $ZippedDestinationFileName = Join-Path $LocalPath $ZippedFileName.Name
    Write-Host "  Copying $ZippedFileName to $ZippedDestinationFileName from $DockerHost ..." -ForegroundColor Gray
    $cs = New-PSSession -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption    
    Copy-Item -Path $ZippedFileName -Destination $ZippedDestinationFileName -FromSession $cs -Recurse
    Remove-PSSession -Session $cs

    #Unzip
    Write-Host "  Extracting $ZippedDestinationFileName..." -ForegroundColor Gray
    Unblock-File $ZippedDestinationFileName
    Expand-Archive $ZippedDestinationFileName $LocalPath -Force

    #Clean Zip Files
    Remove-Item -Path $ZippedDestinationFileName -ErrorAction SilentlyContinue -Force
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ZippedFileName
        )

        Remove-Item -Path $ZippedFileName -ErrorAction SilentlyContinue -Force
    } -ArgumentList $ZippedFileName -ErrorAction Stop
}