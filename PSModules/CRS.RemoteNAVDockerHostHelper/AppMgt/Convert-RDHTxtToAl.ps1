function Convert-RDHTxtToAl {
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
        [Parameter(Mandatory = $false)]
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

    Write-host "Converting $TxtFile on Container $ContainerName on remote dockerhost $DockerHost" -ForegroundColor Green

    Copy-FileToDockerHost `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerDestinationFolder "C:\ProgramData\navcontainerhelper\ConvertTxt2Al" `
        -FileName $TxtFile `
        -ErrorAction Stop
    
    $LocalTxtFile = Join-Path "C:\ProgramData\navcontainerhelper\ConvertTxt2Al" (get-item $TxtFile).Name

    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
        param(
            $ContainerName, $LocalTxtFile, $sqlCredential, $startId, $objectsFilter
        )

        $OriginalFolder = "C:\ProgramData\navcontainerhelper\ConvertTxt2Al\Original"
        $ModifiedFolder = "C:\ProgramData\navcontainerhelper\ConvertTxt2Al\Modified"
        $DeltaFolder = "C:\ProgramData\navcontainerhelper\ConvertTxt2Al\Delta"
        $AlFolder = "C:\ProgramData\navcontainerhelper\ConvertTxt2Al\Al"
        
        $OriginalObjectsStore = "C:\ProgramData\NavContainerHelper\Extensions\Original-$(Get-NavContainerNavVersion -containerOrImageName $ContainerName)-newsyntax"

        if (!(Test-path $OriginalObjectsStore)) {
            Export-NavContainerObjects `
                -containerName $ContainerName `
                -objectsFolder $OriginalObjectsStore `
                -sqlCredential $sqlCredential `
                -exportTo 'txt folder (new syntax)' `
                -filter ''
        }

        Import-ObjectsToNavContainer `
            -containerName $ContainerName `
            -ObjectsFile $LocalTxtFile `
            -sqlCredential $sqlCredential

        Compile-ObjectsInNavContainer `
            -containerName $ContainerName `
            -filter 'Compiled=0' `
            -sqlCredential $sqlCredential `
            -ErrorAction Continue

        Remove-Item -Path $OriginalFolder -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $ModifiedFolder -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $DeltaFolder -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $AlFolder -Recurse -Force -ErrorAction SilentlyContinue
        
        Export-NavContainerObjects `
            -containerName $ContainerName `
            -objectsFolder $ModifiedFolder `
            -sqlCredential $sqlCredential `
            -exportTo 'txt file (new syntax)' `
            -filter $objectsFilter 
        
        Create-MyOriginalFolder `
            -originalFolder $OriginalObjectsStore `
            -modifiedFolder $ModifiedFolder `
            -myOriginalFolder $OriginalFolder

        Create-MyDeltaFolder `
            -containerName $ContainerName `
            -modifiedFolder $ModifiedFolder `
            -myOriginalFolder $OriginalFolder `
            -myDeltaFolder $DeltaFolder 
        
        Convert-Txt2Al `
            -containerName $ContainerName `
            -myDeltaFolder $DeltaFolder `
            -myAlFolder $AlFolder `
            -startId $startId

        Compress-Archive `
            -Path "$AlFolder\*.*" `
            -DestinationPath "$AlFolder.zip" `
            -Force

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