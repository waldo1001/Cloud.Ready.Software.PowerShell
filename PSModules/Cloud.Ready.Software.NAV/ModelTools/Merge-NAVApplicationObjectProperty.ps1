function Merge-NAVApplicationObjectProperty
{
    [CmdletBinding()]
    Param(
        [Bool] $UpdateDateTime,
        [Bool] $UpdateVersionList,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.ApplicationObjectFileInfo] $Original,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.ApplicationObjectFileInfo] $Modified,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.ApplicationObjectFileInfo] $Target,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.ApplicationObjectFileInfo] $Conflict,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.ApplicationObjectFileInfo] $Result,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Dynamics.Nav.Model.Tools.MergeResult] $MergeResult,
        [String[]]$VersionListPrefixes
    )
    begin{
        $Errors = @()
    }
    Process{
        Try{
           switch ($True)
           {
             ($UpdateDateTime -and $UpdateVersionList)            
                {
                    Write-Verbose "Updating DateTime and VersionList for $($Modified.ObjectType) $($Modified.Id)" 
                    Set-NAVApplicationObjectProperty `
                                    -Target $Result `
                                    -VersionListProperty (Merge-NAVVersionList `                                                                        -OriginalVersionList $Original.VersionList `
                                                                        -ModifiedVersionList $Modified.VersionList `
                                                                        -TargetVersionList $Target.VersionList `
                                                                        -Versionprefix $VersionListPrefixes) `
                                    -DateTimeProperty (Merge-NAVDateTime -OriginalDate $Original.Date `
                                                                        -OriginalTime $Original.Time `
                                                                        -ModifiedDate $Modified.Date `
                                                                        -ModifiedTime $Modified.Time `
                                                                        -TargetDate $Target.Date `
                                                                        -TargetTime $Target.Time)   
                }
             ($UpdateDateTime -and (-not $UpdateVersionList))
                { 
                    Write-Verbose "Updating DateTime for $($Modified.ObjectType) $($Modified.Id)" 
                    Set-NAVApplicationObjectProperty `
                                    -Target $Result `
                                    -DateTimeProperty (Merge-NAVDateTime -OriginalDate $Original.Date `
                                                                        -OriginalTime $Original.Time `
                                                                        -ModifiedDate $Modified.Date `
                                                                        -ModifiedTime $Modified.Time `
                                                                        -TargetDate $Target.Date `
                                                                        -TargetTime $Target.Time)                   
                }
             ($UpdateVersionList -and (-not $UpdateDateTime))
                { 
                    Write-Verbose "Updating VersionList for $($Modified.ObjectType) $($Modified.Id)" 
                    Set-NAVApplicationObjectProperty `
                                    -Target $Result `
                                    -VersionListProperty (Merge-NAVVersionList `                                                                        -OriginalVersionList $Original.VersionList `
                                                                        -ModifiedVersionList $Modified.VersionList `
                                                                        -TargetVersionList $Target.VersionList `
                                                                        -Versionprefix $VersionListPrefixes) `               
                }
           }        
        }
        catch{
            $ManagedError = $false

            IF ([String]::IsNullOrEmpty($Target.FileName)) {
                $Errors += "No Target object for $($Original.ObjectType) $($Original.Id) ($_)"
                $ManagedError = $true
            }

            if (-not $ManagedError) {
                $Errors += "Unknown error for object '$($Modified.ObjectType) $($Modified.Id)' $_"
            }
            
        }     
    }
    end{
        if (-not [String]::IsNullOrEmpty($Errors)){
            Write-Host 'ATTENTION: Errors in function ''Merge-NAVApplicationObjectProperty'':' -ForegroundColor Red
            ForEach ($Error in $Errors){
                write-error $Error
            }
        }

    }
}
                    
