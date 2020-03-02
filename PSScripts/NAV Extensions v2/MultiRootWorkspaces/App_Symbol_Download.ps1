. (Join-path $PSScriptRoot '_Settings.ps1')


foreach ($Target in $Targets) {
    #Get app.json
    $AppJson = Get-ObjectFromJSON (Join-Path $target "app.json")
    $LaunchJson = Get-ObjectFromJSON (Join-Path $target ".vscode/launch.json")

    if ($LaunchJson.configurations[0].authentication -ne 'Windows') {
        if (!$Credential) {
            $Credential = Get-Credential
            $BasicAuthentication = $true
        } 
    }
    else {
        $Credential = $null
        $BasicAuthentication = $false
    }

    #system
    if ($AppJson.platform) {
        Get-BCAppSymbols `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -AppPublisher 'Microsoft' `
            -AppName 'System' `
            -AppVersion $AppJson.platform `
            -OutputPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential `
            -BasicAuthentication:$BasicAuthentication
    }
    if ($AppJson.Application) {
        Get-BCAppSymbols `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -AppPublisher 'Microsoft' `
            -AppName 'Application' `
            -AppVersion $AppJson.Application `
            -OutputPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential `
            -BasicAuthentication:$BasicAuthentication
    }
    #Dependencies
    foreach ($Dependency in $AppJson.dependencies) {
        Get-BCAppSymbols `
            -Server $LaunchJson.configurations[0].server `
            -Port $LaunchJson.configurations[0].port `
            -ServerInstance $LaunchJson.configurations[0].serverInstance `
            -AppPublisher $Dependency.publisher `
            -AppName $Dependency.name `
            -AppVersion $Dependency.version `
            -OutputPath (join-path $target ".alpackages") `
            -Authentication $LaunchJson.configurations[0].authentication `
            -Credential $Credential `
            -BasicAuthentication:$BasicAuthentication
    }

}

