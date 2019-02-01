function New-NCHNAVSuperUser {
    <#
    .SYNOPSIS
    Create a super user on a NAVContainer on a Remote Docker Host
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ContainerName
    The Container
    
    .PARAMETER Username
    The Username
    
    .PARAMETER Password
    The password (will be converted to secure string)
    
    .PARAMETER CreateWebServicesKey
    Switch to create a webserviceskey on the way..
    
    .EXAMPLE
    Create a new user "waldo2"

    New-NCHNAVSuperUser `
        -ContainerName $Containername `
        -Username 'waldo2' `
        -Password (ConvertTo-SecureString 'waldo1234' -AsPlainText -Force) `
        -CreateWebServicesKey
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $Username,
        [Parameter(Mandatory = $true)]
        [SecureString] $Password,
        [Parameter(Mandatory = $false)]
        [switch] $CreateWebServicesKey        
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        param(
            $CreateWebServicesKey, $Username, [SecureString] $Password
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
    } -ArgumentList $CreateWebServicesKey, $Username, $Password
    
}