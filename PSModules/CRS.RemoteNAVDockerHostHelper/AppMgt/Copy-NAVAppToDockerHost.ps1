function Copy-NAVAppToDockerHost {
    param(
        [Parameter(Mandatory = $true)]
        [String] $DockerHost,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $UseSSL,
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $AppFileName
    )

    $AppFileContent = get-content $AppFileName -Raw
     
    Invoke-Command -ComputerName $DockerHost -UseSSL:$UseSSL -Credential $DockerHostCredentials -ScriptBlock {
        param(
            $ContainerName,$AppFileName,$AppFileContent
        )

        #Create Dir is necessary
        New-Item -ItemType directory -Path "C:\ProgramData\navcontainerhelper\$ContainerName" -ErrorAction Ignore

        #Save App
        $AppPath = "C:\ProgramData\navcontainerhelper\$ContainerName\$AppFileName"
        Set-Content -Value $AppFileContent -Path $AppPath -Force 
        
        return $AppPath
    }   -ArgumentList $ContainerName,(get-item $AppFileName).Name ,$AppFileContent

}