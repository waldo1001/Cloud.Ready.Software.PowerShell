function New-RDHNAVSuperUser {
    <#
    .SYNOPSIS
    Create a super user on a NAVContainer on a Remote Docker Host
    
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
    
    .PARAMETER Username
    The Username
    
    .PARAMETER Password
    The password (will be converted to secure string)
    
    .PARAMETER CreateWebServicesKey
    Switch to create a webserviceskey on the way..
    
    .EXAMPLE
    New-RDHNAVSuperUser `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $Containername `
        -Username 'waldo2' `
        -Password (ConvertTo-SecureString 'waldo1234' -AsPlainText -Force) `
        -CreateWebServicesKey
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String] $DockerHost,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential] $DockerHostCredentials,
        [Parameter(Mandatory = $false)]
        [Switch] $DockerHostUseSSL,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.Remoting.PSSessionOption] $DockerHostSessionOption,
        [Parameter(Mandatory=$true)]
        [String] $ContainerName,
        [Parameter(Mandatory=$true)]
        [String] $Username,
        [Parameter(Mandatory=$true)]
        [SecureString] $Password,
        [Parameter(Mandatory=$false)]
        [switch] $CreateWebServicesKey        
    )
    
    Invoke-Command -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption -ScriptBlock {
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
                -Password $Password `
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

