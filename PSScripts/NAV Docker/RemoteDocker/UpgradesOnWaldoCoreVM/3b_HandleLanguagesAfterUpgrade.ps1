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

$ResultWithLanguages = Join-Path $UpgradeSettings.ResultFolder "ResultWithLanguages"

Remove-Item -Path $ResultWithLanguages -Force -ErrorAction SilentlyContinue
New-Item -Path $ResultWithLanguages -ItemType Directory -ErrorAction SilentlyContinue

Copy-Item -Path (Join-Path $UpgradeSettings.ResultFolder "MergeResult_ChangedOnly\*.txt") -Destination $ResultWithLanguages

#Original First
get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.OriginalVersion)*" |
    foreach {
        $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
        $languagePath = $_.FullName
        Write-host "Processing $languagePath"

        Get-ChildItem $ResultWithLanguages | % {
            Write-Host "Processing $($_.FullName)"
            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source $_.FullName `
                -Destination $_.FullName `
                -Force `
                -WarningAction SilentlyContinue            
        }        
    }

#Then Modified
get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.ModifiedVersion)*" |
    foreach {
        $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
        $languagePath = $_.FullName
        Write-host "Processing $languagePath"

        Get-ChildItem $ResultWithLanguages | % {
            Write-Host "Processing $($_.FullName)"
            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source $_.FullName `
                -Destination $_.FullName `
                -Force `
                -WarningAction SilentlyContinue            
        }        
    }

#Target Last
get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.TargetVersion)*" |
    foreach {
        $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
        $languagePath = $_.FullName
        Write-host "Processing $languagePath"

        Get-ChildItem $ResultWithLanguages | % {
            Write-Host "Processing $($_.FullName)"
            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source $_.FullName `
                -Destination $_.FullName `
                -Force `
                -WarningAction SilentlyContinue            
        }        
    }

Join-NAVApplicationObjectFile -Source "$ResultWithLanguages\*.txt" -Destination "$ResultWithLanguages.txt"