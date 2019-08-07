function Install-NCHNavApp {
    <#
    .SYNOPSIS
    Installs App on a NAV Container.
    
    .PARAMETER ContainerName
    ContainerName
    
    .PARAMETER Path
    The path to the .app-file
        
    #>

    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $Path,
        [Parameter(Mandatory = $true)]
        [switch] $DoNotDeleteAppFile
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        param(
            $Path
        )
    
        $App = Get-NAVAppInfo -Path $Path

        $SC = Get-NAVServerInstance
        
        # $SC | Get-NAVAppInfo -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
        # Uninstall-NAVApp 
        
        # $SC | Get-NAVAppInfo -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
        # Unpublish-NAVApp
        
        $SC | Publish-NAVApp `
            -Path $Path `
            -SkipVerification
        
        $SC | Sync-NAVApp `
            -Name $App.Name `
            -Publisher $App.Publisher `
            -Version $App.Version `
            -ErrorAction Stop    
        
        $SC | Install-navapp `
            -Name $App.Name `
            -Publisher $App.Publisher `
            -Version $App.Version `
            -ErrorAction Stop                
        
        Write-host "  Installed $($App.Name) from $($App.Publisher)" -ForegroundColor Gray
        
        if (-not $DoNotDeleteAppFile) {
            Remove-Item -Path $Path -Force
        }
    }   -ArgumentList $Path

}