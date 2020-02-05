. (Join-path $PSScriptRoot '_Settings.ps1')

foreach ($Target in $Targets) {
    #Get app.json
    $AppJson = Get-ObjectFromJSON (Join-Path $target "app.json")
    $LaunchJson = Get-ObjectFromJSON (Join-Path $target ".vscode/launch.json")

    if ($LaunchJson.configurations[0].authentication -ne 'Windows') {
        if (!$Credential) {
            $Credential = Get-Credential
        }
    }

    #system
    if ($AppJson.platform) {
        Get-AlSymbolFile `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -Publisher 'Microsoft' `
            -AppName 'System' `
            -VersionText $AppJson.platform `
            -OutPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential
    }
    if ($AppJson.Application) {
        Get-AlSymbolFile `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -Publisher 'Microsoft' `
            -AppName 'Application' `
            -VersionText $AppJson.Application `
            -OutPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential
    }
    #Dependencies
    foreach ($Dependency in $AppJson.dependencies) {
        Get-AlSymbolFile `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -Publisher $Dependency.publisher `
            -AppName $Dependency.name `
            -VersionText $Dependency.version `
            -OutPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential
    }

}

