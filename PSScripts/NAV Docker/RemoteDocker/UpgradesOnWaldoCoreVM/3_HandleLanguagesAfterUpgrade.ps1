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

$ResultWithoutLanguages = Join-Path $ResultFolder "ResultWithoutLanguages.txt"
$ResultWithLanguages = Join-Path $ResultFolder "ResultWithLanguages.txt"

#Join First (languages need to be added all in the same destination)
Join-NAVApplicationObjectFile `
    -Source (Join-Path $ResultFolder "MergeResult_ChangedOnly\*.txt") `
    -Destination $ResultWithoutLanguages

#Original First
get-childitem $LanguageFolder -Filter "$OriginalVersion*" |
    foreach {
        Import-NAVApplicationObjectLanguage `
    }
    
#Then Modified
$LanguageFiles = get-childitem $LanguageFolder -Filter "$ModifiedVersion*"

#Target Last
$LanguageFiles = get-childitem $LanguageFolder -Filter "$TargetVersion*"

#Split
$ResultWithLanguagesFolder = Join-Path $ResultFolder "ResultWithLanguages"
Split-NAVApplicationObjectFile `
    -Source $ResultWithLanguages `
    -Destination $ResultWithLanguagesFolder