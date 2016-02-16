function Deploy-NAVXPackage
{

    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory=$true)]
        [String] $PackageFile,
        [Parameter(Mandatory=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$false)]
        [String] $Tenant='Default',
        [Switch] $DoNotSaveData,
        [Switch] $Force
        
    )
    
    $PublishedApps = Get-NAVAppInfo -ServerInstance $ServerInstance -ErrorAction Stop
    $InstalledApps = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -ErrorAction Stop
    $myApp = Get-NAVAppInfo -Path $PackageFile -ErrorAction Stop

 
    $RemoveApp = $InstalledApps | Where Name -eq $MyApp.Name | Where Publisher -eq $MyApp.Publisher
    if ($RemoveApp){
        Write-Host -ForegroundColor Green "Uninstalling $($RemoveApp.Name) version $($RemoveApp.Version) from $ServerInstance tenant $Tenant"
        if ($DoNotSaveData){
            if(!$Force) {                
                if(!(Confirm-YesOrNo -title "Deleting $($RemoveApp.Name) without saving data!" -message "Are you sure to uninstall $($RemoveApp.Name) version $($RemoveApp.Version) from $ServerInstance tenant $Tenant")){                    
                    break
                }
            }
        }
        $RemoveApp | Uninstall-navapp -ServerInstance $ServerInstance -Tenant $Tenant -DoNotSaveData:$DoNotSaveData -ErrorAction Stop        
        
        # unpublish App, if Data don't has to be saved so a re-deploy of the same App Version is possible
        if ($DoNotSaveData){
            $RemoveApp = $PublishedApps | Where Name -eq $MyApp.Name | Where Publisher -eq $MyApp.Publisher | Where Version -eq $MyApp.Version
            if ($RemoveApp){
                Write-Host -ForegroundColor Green "Unpublishing $($RemoveApp.Name) version $($RemoveApp.Version) from $ServerInstance"        
                $RemoveApp | Unpublish-NAVApp -ServerInstance $ServerInstance -ErrorAction Stop 
            }    
        }
    }
    
    write-host -ForegroundColor Green "Publishing $($myApp.Name) version $($myApp.Version) on $ServerInstance"
    Publish-NAVApp -Path $PackageFile -ServerInstance $ServerInstance -ErrorAction Stop

    write-host -ForegroundColor Green "Installing $($myApp.Name) version $($myApp.Version) on $ServerInstance and tenant $Tenant"
    $InstalledApp = $myApp | Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -ErrorAction Stop -PassThru

    Write-host -ForegroundColor Green -Object 'Installed App:'
    Write-host -ForegroundColor Green -Object "   Name: $($InstalledApp.Name)"
    Write-host -ForegroundColor Green -Object "   Publisher: $($InstalledApp.Publisher)"
    Write-host -ForegroundColor Green -Object "   ServerInstance: $($InstalledApp.ServerInstance)"
    Write-host -ForegroundColor Green -Object "   Version: $($InstalledApp.Version)"

    $InstalledApp

}

