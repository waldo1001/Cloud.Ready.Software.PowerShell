$Target = "PNS-REQ"
$TargetName = 'Pack And Ship Transport Requests'
$TargetAffix = "IFC"
$FromRange = 2038730 
$ToRange = 2038799

$FromTestRange = 81585
$ToTestRange = 81594

$Dependencies = @("PACKNSHIP")#"ENV","REST")#@("FILE","TOPIC","ENV","REST","META","ECF")#@("SALESPURCH","CP")

#####################################
$RootDir = "D:\iFacto\DistriApps\"
$Template = "_script\_template\"
#####################################

$Sources = Join-Path -Path $RootDir -ChildPath $Template
$TargetPath = Join-Path -Path $RootDir -ChildPath $Target

Copy-Item -Recurse -Path "$($Sources)\*" -Destination $TargetPath

Rename-Item "$($TargetPath)\ENVI.code-workspace" -NewName "$($Target).code-workspace"

$AppGuid = (New-Guid).Guid
$TestGuid = (New-Guid).Guid

$AppJsonPath = "$($TargetPath)\App\app.json"
$TestJsonPath = "$($TargetPath)\Test\app.json"

$AppJson = (Get-Content -Path $AppJsonPath -Raw) | ConvertFrom-Json
$TestJson = (Get-Content -Path $TestJsonPath -Raw) | ConvertFrom-Json

$AppJson.id = $AppGuid
$AppJson.idRanges[0].from = $FromRange
$AppJson.idRanges[0].to = $ToRange
$AppJson.name = "$($TargetName)"
$AppJson.description = "$($TargetName) Distri App"
$AppJson.brief = $AppJson.description

$TestJson.id = $TestGuid
$TestJson.idRanges[0].from = $FromTestRange
$TestJson.idRanges[0].to = $ToTestRange
$TestJson.name = "DISTRI-$($Target)-TEST"
$TestJson.description = "$($TargetName) Distri Test App"
$TestJson.brief = $TestJson.description

$TestJson.dependencies += [PSObject]@{
    id = $AppGuid
    publisher = $AppJson.publisher
    name = $AppJson.name
    version = $AppJson.version
    }

foreach ($Dependency in $Dependencies)
{
    $DepPath = Join-Path -Path $RootDir -ChildPath $Dependency
    $DepJson = (Get-Content -Path "$($DepPath)\App\app.json" -Raw) | ConvertFrom-Json
    $TestDepJson = (Get-Content -Path "$($DepPath)\Test\app.json" -Raw) | ConvertFrom-Json

    $AppJson.dependencies += [PSObject]@{
                                            id = $DepJson.id
                                            publisher = $DepJson.publisher
                                            name = $DepJson.name
                                            version = $DepJson.version
                                        }
    $TestJson.dependencies += [PSObject]@{
                                            id = $DepJson.id
                                            publisher = $DepJson.publisher
                                            name = $DepJson.name
                                            version = $DepJson.version
                                        }

    $TestJson.dependencies += [PSObject]@{
                                            id = $TestDepJson.id
                                            publisher = $TestDepJson.publisher
                                            name = $TestDepJson.name
                                            version = $TestDepJson.version
                                        }
}

$AppJson | ConvertTo-Json -Depth 100 | Set-Content -Path $AppJsonPath
$TestJson | ConvertTo-Json -Depth 100 | Set-Content -Path $TestJsonPath

$PipelinesToChange = @("azure-pipelines.yml","\PREP\azure-pipelines-current.yml", "\PREP\azure-pipelines-next.yml", "\PREP\azure-pipelines-nextmajor.yml")

foreach ($PipelineToChange in $PipelinesToChange) {
    ## Pipeline
    $PipelinePath = Join-Path -Path $TargetPath -ChildPath $PipelineToChange
    $Pipeline = Get-Content $PipelinePath -Raw
    
    $Pipeline = $Pipeline.Replace("ENVITEST",$Target.Substring(0,[System.Math]::Min(10, $Target.Length)))
    $Pipeline = $Pipeline.Replace("ENVI",$Target)    

    $DependencySource = "#End Dependencies"

    foreach ($Dependency in $Dependencies)
    {
        $DependencyPipeline = @"
- template: .tasks/PublishApp/iFactoBusinessSolutionsNV/DistriApps/$($Dependency).yml@templates    
- template: .tasks/PublishApp/iFactoBusinessSolutionsNV/DistriApps/$($Dependency)_TEST.yml@templates

$DependencySource
"@
        $Pipeline = $Pipeline.Replace($DependencySource,$DependencyPipeline)
    }

    $Pipeline | Set-Content -Path $PipelinePath
}

## Settings
$AppSettingsPath = Join-Path -Path $TargetPath -ChildPath "\App\.vscode\settings.json"
$TestSettingsPath = Join-Path -Path $TargetPath -ChildPath "\Test\.vscode\settings.json"
$AppSettings = Get-Content -Raw $AppSettingsPath 
$TestSettings = Get-Content -Raw $TestSettingsPath 

$AppSettings = $AppSettings.Replace("ENVI",$TargetAffix)
$TestSettings = $TestSettings.Replace("ENVI",$TargetAffix)

$AppSettings | Set-Content -Path $AppSettingsPath
$TestSettings | Set-Content -Path $TestSettingsPath

## AppSourceCop
$AppAppSourceCopPath = Join-Path -Path $TargetPath -ChildPath "\App\AppSourceCop.json"
$TestAppSourceCopPath = Join-Path -Path $TargetPath -ChildPath "\Test\AppSourceCop.json"
$AppAppSourceCop = Get-Content -Raw $AppAppSourceCopPath 
$TestAppSourceCop = Get-Content -Raw $TestAppSourceCopPath 

$AppAppSourceCop = $AppAppSourceCop.Replace("ENVI",$TargetAffix)
$TestAppSourceCop = $AppAppSourceCop.Replace("ENVI",$TargetAffix)

$AppAppSourceCop | Set-Content -Path $AppAppSourceCopPath
$TestAppSourceCop | Set-Content -Path $TestAppSourceCopPath

## Test Codeunits
$InstallCodeunit = Join-Path -Path $TargetPath -ChildPath "\Test\Src\ENVITestInstall.Codeunit.al"
$UpgCodeunit = Join-Path -Path $TargetPath -ChildPath "\Test\Src\ENVITestUpgrade.Codeunit.al"

$InstallCode = Get-Content $InstallCodeunit -Raw
$InstallCode = $InstallCode.Replace("ENVI",$TargetAffix)
$InstallCode = $InstallCode.Replace("80600",$FromTestRange)
$InstallCode | Set-Content $InstallCodeunit

Rename-Item -Path $InstallCodeunit -NewName "$($TargetAffix)TestInstall.Codeunit.al"

$UpgCode = Get-Content $UpgCodeunit -Raw
$UpgCode = $UpgCode.Replace("ENVI",$TargetAffix)
$UpgCode = $UpgCode.Replace("80601",$FromTestRange+1)
$UpgCode | Set-Content $UpgCodeunit

Rename-Item -Path $UpgCodeunit -NewName "$($TargetAffix)TestUpgrade.Codeunit.al"

Write-Host -ForegroundColor Yellow "Check if base needs to be installed in pipeline"

# Extra todo:
# - Change image
# - Add DistriApp Template yaml
# - After build, enable breaking check
# - master branch policy
# - Release pipeline deploy app
