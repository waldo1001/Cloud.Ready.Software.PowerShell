function New-NAVContainerSuperUserOnDockerHost {
    param(
        [Parameter(Mandatory=$true)]
        [String] $DockerHost,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $UseSSL,
        [Parameter(Mandatory=$true)]
        [String] $ContainerName,
        [Parameter(Mandatory=$true)]
        [String] $Username,
        [Parameter(Mandatory=$true)]
        [SecureString] $Password,
        [Parameter(Mandatory=$false)]
        [switch] $CreateWebServicesKey        
    )
    
    Invoke-Command -ComputerName $DockerHost -UseSSL:$UseSSL -Credential $DockerHostCredentials -ScriptBlock {
        param(
            $ContainerName,$CreateWebServicesKey,$Username,[SecureString] $Password
        )
    
        $Session = Get-NavContainerSession -containerName $ContainerName
        Invoke-Command -Session $Session -ScriptBlock {
            param(
                $CreateWebServicesKey,$Username,[SecureString] $Password
            )
            
            New-NAVServerUser `
                -ServerInstance NAV `
                -UserName $username  `
                -Password (ConvertTo-SecureString $pwd -AsPlainText -Force) `
                -CreateWebServicesKey:$CreateWebServicesKey
        
            New-NAVServerUserPermissionSet `
                -Scope System `
                -ServerInstance NAV `
                -PermissionSetId SUPER `
                -UserName $username 
            
            Write-Host "UID: $username successfully created!"
            
            if ($CreateWebServicesKey) {
                write-Host "  WS-Key: $((Get-NAVServerUser -ServerInstance NAV | where username -like $username).WebServicesKey)"
            }
                
        }  -ArgumentList $CreateWebServicesKey,$Username,$Password
        
    
    } -ArgumentList $ContainerName,$CreateWebServicesKey,$Username,$Password
}

