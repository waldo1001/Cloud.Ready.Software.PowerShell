function Get-NCHCustomNAVApps {
    <#
    .SYNOPSIS
    Gets all non-Microsoft Apps from a Container
    
    .PARAMETER ContainerName
    The Container
    
    .EXAMPLE
    Get-NCHCustomNAVApps `
        -ContainerName $Containername 
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    $Session = Get-NavContainerSession -containerName $ContainerName
    Invoke-Command -Session $Session -ScriptBlock {
   
        Return Get-NAVAppInfo -ServerInstance NAV | Where Publisher -ne 'Microsoft'
    }   
}