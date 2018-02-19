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
        [String] $Path
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    $Session = Get-NavContainerSession -containerName $ContainerName
    Invoke-Command -Session $Session -ScriptBlock {
        param(
            $Path
        )
    
        $App = Get-NAVAppInfo -Path $Path
        
        Get-NAVAppInfo -ServerInstance NAV -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
            Uninstall-NAVApp 
        
        Get-NAVAppInfo -ServerInstance NAV -Name $App.Name -Publisher $App.Publisher -Version $App.Version |
            Unpublish-NAVApp
        
        Publish-NAVApp `
            -ServerInstance NAV `
            -Path $Path `
            -SkipVerification
        
        Sync-NAVApp `
            -ServerInstance NAV `
            -Name $App.Name `
            -Publisher $App.Publisher `
            -Version $App.Version `
            -ErrorAction Stop    
        
        Install-navapp `
            -ServerInstance NAV `
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