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
    
    .PARAMETER ContainerDestinationFolder
    The folder where the file needs to end up on the remote Computer
    
    .PARAMETER FileName
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
        [String] $ContainerDestinationFolder,
        [Parameter(Mandatory = $true)]
        [String] $FileName        
    )
    
    Write-Host "Copying $FileName to Container $ContainerName on Docker Host $DockerHost" -ForegroundColor Green

    #Zip
    if ([io.path]::GetExtension($FileName) -ne '.zip'){
        $ZippedFileName = "$FileName.zip"
        Write-Host "  Compressing $FileName..." -ForegroundColor Gray
        Compress-Archive -Path $FileName -DestinationPath $ZippedFileName -Force
    } else {
        $ZippedFileName = $FileName
    }
    
    #Create folder if not exists
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerDestinationFolder
        )
        
        #Create Folder if not exists
        If (!(Test-Path $ContainerDestinationFolder)){
            Write-Host -ForegroundColor Gray "  Creating folder $ContainerDestinationFolder on Docker Host"
            New-Item -Path $ContainerDestinationFolder -ItemType Directory -Force
        }

    } -ArgumentList $ContainerDestinationFolder -ErrorAction Stop

    #Copy
    $ZippedDestinationFileName = Join-Path $ContainerDestinationFolder (get-item $ZippedFileName).Name
    Write-Host "  Copying $ZippedFileName to $ZippedDestinationFileName on $DockerHost ..." -ForegroundColor Gray
    $cs = New-PSSession -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption    
    Copy-Item $ZippedFileName -Destination $ZippedDestinationFileName -ToSession $cs -Recurse

    #    $FileContent = get-content $ZippedFileName -Raw
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $ContainerDestinationFolder, $FileName, $ZippedDestinationFileName
        )
        
        #Unzip
        Write-Host "  Extracting $ZippedDestinationFileName..." -ForegroundColor Gray
        Unblock-File $ZippedDestinationFileName
        Expand-Archive $ZippedDestinationFileName $ContainerDestinationFolder -Force
        
        #Remove Zip
        Write-Host "  Removing $ZippedDestinationFileName..." -ForegroundColor Gray
        Remove-Item $ZippedDestinationFileName -Force

    } -ArgumentList $ContainerName, $ContainerDestinationFolder, (get-item $FileName).Name , $ZippedDestinationFileName
}