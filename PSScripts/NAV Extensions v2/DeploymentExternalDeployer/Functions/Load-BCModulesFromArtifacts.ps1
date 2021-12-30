function Load-BCModulesFromArtifacts {
    [CmdletBinding()]
    param (
        [string] $ArtifactsCachePath = 'C:\bcartifacts.cache'
    )

    $MgtDll = "Microsoft.Dynamics.Nav.Apps.Management"

    $MgtModuleLoaded = Get-Module | where Name -eq "$MgtDll"
    
    if (!$MgtModuleLoaded){ 
        import-module (Get-ChildItem $ArtifactsCachePath -Recurse -Filter "$MgtDll.dll" | Sort CreationTime -Descending)[0].FullName 
    }

}