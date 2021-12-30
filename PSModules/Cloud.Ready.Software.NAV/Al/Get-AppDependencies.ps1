function Get-AppDependencies {
    [CmdletBinding()]
    param(            
        [String] $Path,
        [ValidateSet('AppFiles', 'ALFolders')]
        [String] $Type
    )
    
    function AddToDependencyTree() {
        param(
            [PSObject] $App,
            [PSObject[]] $DependencyArray,
            [PSObject[]] $AppCollection,
            [Int] $Order = 1
        )   

        
        foreach ($Dependency in $App.Dependencies) {
            if (!$Dependency.id){
                $Dependency | Add-Member -MemberType NoteProperty -Name "id" -Value $Dependency.AppId
            }

            $AppInAppCollection = $AppCollection | where id -eq $Dependency.id
            if ($AppInAppCollection) {
                $DependencyArray = AddToDependencyTree `
                    -App ($AppCollection | where id -eq $Dependency.id) `
                    -DependencyArray $DependencyArray `
                    -AppCollection $AppCollection `
                    -Order ($Order - 1)
            }
        }

        if (!$App.id){
            $App | Add-Member -MemberType NoteProperty -Name "id" -Value $App.AppId
        }

        if (-not($DependencyArray | where { $_.id -eq $App.id })) {
            $DependencyArray += $App
            try {
                ($DependencyArray | where { $_.id -eq $App.id }).ProcessOrder = $Order
            }
            catch { }
        }
        else {
            if (($DependencyArray | where { $_.id -eq $App.id }).ProcessOrder -gt $Order) {
                ($DependencyArray | where { $_.id -eq $App.id }).ProcessOrder = $Order
            } 
        }

        $DependencyArray
    }

    #Script execution
    #. (Join-Path $PSScriptRoot "GetDependencies_TestApps.ps1")

    if ($Path -eq "") {
        $Path = "C:\ProgramData\NavContainerHelper\DependencyApps"
    }
    
    switch ($Type) {
        "AppFiles" {
            $AllAppFiles = Get-ChildItem -Path $Path -Filter "*.app" -recurse 
        
            $AllApps = @()
            foreach ($AppFile in $AllAppFiles) {
                $App = Get-NAVAppInfo -Path $AppFile.FullName
                $AllApps += [PSCustomObject]@{
                    id           = $App.AppId
                    Version      = $App.version
                    Name         = $App.name
                    Publisher    = $App.publisher
                    ProcessOrder = 0                            
                    Dependencies = $App.dependencies
                    Path         = $AppFile.FullName
                }
            }
        }
        "ALFolders" {
            $AllAppFiles = Get-ChildItem -Path $Path -Filter "app.json" -recurse 
        
            $AllApps = @()
            foreach ($AppFile in $AllAppFiles) {
                $App = Get-ObjectFromJSON $AppFile.FullName # Get-NAVAppInfo -Path $AppFile.FullName
                $AllApps += [PSCustomObject]@{
                    id           = $App.id
                    Version      = $App.version
                    Name         = $App.name
                    Publisher    = $App.publisher
                    ProcessOrder = 0                            
                    Dependencies = $App.dependencies
                    Path         = $AppFile.FullName
                }
            }
        }
        Default {
            Write-Error "Wrong Type parameter"
        }
    }

    
    $FinalResult = @()

    $AllApps | foreach {    
        $FinalResult = AddToDependencyTree -App $_ -DependencyArray $FinalResult -AppCollection $AllApps -Order $AllApps.Count
    }

    return $FinalResult | Sort ProcessOrder
}