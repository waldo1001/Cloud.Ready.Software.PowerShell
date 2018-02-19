function Sync-NCHNAVTenant {
    <#
    .SYNOPSIS
    Execute Sync-NAVTenant on a container.
    
    .PARAMETER ContainerName
    The container you want to run this function on

    .NOTES
    Executes a Sync-NAVTenant -ServerInstance NAV -Force on the container.
    #> 

    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"
    
    $Session = Get-NavContainerSession -containerName $ContainerName
    Invoke-Command -Session $Session -ScriptBlock {
        Sync-NAVTenant -ServerInstance NAV -Force
    }

}