. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcprivate'
$alProjectFolder = "C:\ProgramData\NavContainerHelper\AL\$($Containername)_Project"

$ContainerDockerImage = 'bcprivate.azurecr.io/bcsandbox-master:base-ltsc2019'
$ContainerDockerImage = 'bcprivate.azurecr.io/bcsandbox-master:be-ltsc2019'
#$ContainerDockerImage = "bcprivate.azurecr.io/bconprem-master"

$registry = $ContainerDockerImage.Substring(0, $ContainerDockerImage.IndexOf('/'))
docker login "$registry" -p "$($SecretSettings.PrivateRegistryPassword)" -u "$($SecretSettings.PrivateRegistryUserName)" -p "$($SecretSettings.PrivateRegistryPassword)"
# "docker login ""$registry"" -p ""$($SecretSettings.PrivateRegistryPassword)"" -u ""$($SecretSettings.PrivateRegistryUserName)"" -p ""$($SecretSettings.PrivateRegistryPassword)"""
# docker login "$registry" -p "8u=1x[vC*nAE0qz7:/ANXs/rm6g7ic[k" -u "514e7607-18c7-4556-8191-90626a1070dc" -p "8u=1x[vC*nAE0qz7:/ANXs/rm6g7ic[k"
                                                                  

$ContainerAlwaysPull = $true
$enableSymbolLoading = $false
$assignPremiumPlan = $false
$includeTestToolkit = $false
$includeTestLibrariesOnly = $false
$InstallDependentModules = $false
$IncludeAL = $true
$memoryLimit = "10g"

$myModifiedObjects = @("page21", "table18") #Just an example
$TypeFolders = { Param ($type, $id, $name) 
    if ($myModifiedObjects.Contains("$type$id")) {
        $folder = "Modified"
    }
    elseif (($id -ge 50000 -and $id -le 99999) -or ($id -gt 1999999999)) {
        $folder = "My"
    }
    else {
        $folder = "BaseApp"
    }

    switch ($type) {
        "page" { "Src\$folder\Pages\$($name).$($type).al" }
        "table" { "Src\$folder\Tables\$($name).$($type).al" }
        "codeunit" { "Src\$folder\Codeunits\$($name).$($type).al" }
        "query" { "Src\$folder\Queries\$($name).$($type).al" }
        "report" { "Src\$folder\Reports\$($name).$($type).al" }
        "xmlport" { "Src\$folder\XmlPorts\$($name).$($type).al" }
        "profile" { "Src\$folder\Profiles\$($name).Profile.al" }
        "dotnet" { "Src\$folder\DotNet$($name).al" }
        ".rdlc" { "Src\$folder\Layouts.rdlc\$name$type" }
        ".docx" { "Src\$folder\Layouts.docx\$name$type" }
        ".xlf" { "Translations\$name$type" }
        default { throw "Unknown type '$type'" }
    }
} 

New-BcContainer -accept_eula `
    -containerName $ContainerName `
    -auth NavUserPassword `
    -Credential $ContainerCredential `
    -updateHosts `
    -licenseFile $SecretSettings.containerLicenseFile `
    -imageName $ContainerDockerImage `
    -includeAL `
    -memoryLimit 10g `
    -useBestContainerOS

Break

Create-AlProjectFolderFromBcContainer `
    -containerName $Containername `
    -alProjectFolder $alProjectFolder `
    -id ([Guid]::NewGuid().ToString()) `
    -name MyCustomBaseApp `
    -publisher waldo `
    -version "1.0.0.0" `
    -useBaseLine `
    -AddGIT `
    -alFileStructure $TypeFolders 


# $Reports = Get-ChildItem -Path $alProjectFolder -Recurse -Filter "*.report.al" #| select -First 1
# foreach ($Report in $Reports) {
#     ($Report | Get-Content -Raw) -replace 'RDLCLayout *= *''(\.+)/(.+).rdlc'';', 'RDLCLayout = ''./Src/BaseApp/Layouts.rdlc/$2.rdlc'';' | Out-File $Report.FullName
#     ($Report | Get-Content -Raw) -replace 'WordLayout *= *''(\.+)/(.+).docx'';', 'WordLayout = ''./Src/BaseApp/Layouts.docx/$2.docx'';' | Out-File $Report.FullName
# }
# Set-Location $AlProjectFolder
# & git add -A -- .
# & git commit -m "reportlayoutfix"


code $alProjectFolder 


$appFile = 
Compile-AppInBCContainer `
    -containerName $ContainerName `
    -appProjectFolder $alProjectFolder `
    -appOutputFolder $alProjectFolder `
    -credential $ContainerCredential 

Publish-NewApplicationToBcContainer `
    -containerName $ContainerName `
    -appFile $appFile `
    -credential $ContainerCredential `
    -useCleanDatabase

break

if ($InstallDependentModules) {
    Install-NCHDependentModules `
        -ContainerName $ContainerName `
        -ContainerModulesOnly
}
    
#Sync-NCHNAVTenant -containerName $ContainerName
    