Get-ChildItem (join-path $PSScriptRoot 'Functions') | % {. ($_.FullName)}

$containerURL = "https://2a1b790adb.infra.ifacto.be"
$Path = "C:\Temp\appsNL"

Load-BCModulesFromArtifacts

$Paths = Get-AppDependencies -Path $Path -Type AppFiles

$AppsToDeploy = $Paths | sort ProcessOrder

if (!$Credential) {
    $Credential = Get-Credential -UserName 'wauteri' -Message 'Provide password'
}

foreach ($AppToDeploy in $AppsToDeploy) {
    Publish-BCAppWithExternalDeployer -Credential $Credential -EnvironmentURL $containerURL -Path $AppToDeploy.Path

    Get-BCDeploymentStatus -Credential $Credential -EnvironmentURL $containerURL
}
