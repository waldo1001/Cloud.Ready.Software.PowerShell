. '.\_Settings.ps1'

<#
"Set-Location $DockerHostScriptLocation" | clip
Enter-PSSession -ComputerName $DockerHost  -Credential (Get-Credential)
#>
<#
. '.\_Settings.ps1'
"Set-Location $DockerHostScriptLocation" | clip
Enter-NavContainer -containerName $DockerContainerName
#>

$ResultWithoutLanguages = Join-Path $UpgradeSettings.ResultFolder "ResultWithoutLanguages.txt"
$ResultWithLanguages = Join-Path $UpgradeSettings.ResultFolder "ResultWithLanguages.txt"

#Join First (languages need to be added all in the same destination)
Join-NAVApplicationObjectFile `
    -Source (Join-Path $UpgradeSettings.ResultFolder "MergeResult_ChangedOnly\*.txt") `
    -Destination $ResultWithoutLanguages

#Original First
get-childitem $LanguageFolder -Filter "$OriginalVersion*" |
    foreach {
        Import-NAVApplicationObjectLanguage `
    }
    
#Then Modified
$LanguageFiles = get-childitem $LanguageFolder -Filter "$ModifiedVersion*"
    foreach {
        Import-NAVApplicationObjectLanguage `
    }

#Target Last
$LanguageFiles = get-childitem $LanguageFolder -Filter "$TargetVersion*"
    foreach {
        Import-NAVApplicationObjectLanguage `
    }

#Split
$ResultWithLanguagesFolder = Join-Path $UpgradeSettings.ResultFolder "ResultWithLanguages"
Split-NAVApplicationObjectFile `
    -Source $ResultWithLanguages `
    -Destination $ResultWithLanguagesFolder