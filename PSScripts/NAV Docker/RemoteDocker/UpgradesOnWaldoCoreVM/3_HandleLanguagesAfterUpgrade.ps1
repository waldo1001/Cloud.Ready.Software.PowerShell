. '.\_Settings.ps1'

Invoke-Command -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption -ScriptBlock {
    param(
        $UpgradeSettings, $ContainerName
    )
    
    Invoke-Command -Session (Get-NavContainerSession -containerName $ContainerName) -ScriptBlock {
        param(
            $UpgradeSettings
        )


        $ResultWithLanguages = Join-Path $UpgradeSettings.ResultFolder "ResultWithLanguages"

        $null = Remove-Item -Path $ResultWithLanguages -Force -ErrorAction SilentlyContinue
        $null = New-Item -Path $ResultWithLanguages -ItemType Directory -ErrorAction SilentlyContinue

        Join-NAVApplicationObjectFile -Source (Join-Path $UpgradeSettings.ResultFolder "MergeResult\*.txt") -Destination "$ResultWithLanguages.txt"
        
        #Copy-Item -Path (Join-Path $UpgradeSettings.ResultFolder "MergeResult\*.txt") -Destination $ResultWithLanguages

        #Original First
        get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.OriginalVersion)*" |
            foreach {
            $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
            $languagePath = $_.FullName
            Write-host "Processing $languagePath"

            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source "$ResultWithLanguages.txt" `
                -Destination "$ResultWithLanguages.txt" `
                -Force `
                -WarningAction SilentlyContinue            
                    
        }

        #Then Modified
        get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.ModifiedVersion)*" |
            foreach {
            $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
            $languagePath = $_.FullName
            Write-host "Processing $languagePath"

            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source "$ResultWithLanguages.txt" `
                -Destination "$ResultWithLanguages.txt" `
                -Force `
                -WarningAction SilentlyContinue            
        }

        #Target Last
        get-childitem $UpgradeSettings.LanguagesFolder -Filter "$($UpgradeSettings.TargetVersion)*" |
            foreach {
            $languageId = $_.BaseName.Substring($_.BaseName.Length - 3)
            $languagePath = $_.FullName
            Write-host "Processing $languagePath"

            Import-NAVApplicationObjectLanguage `
                -LanguageId $languageId `
                -LanguagePath $languagePath `
                -Source "$ResultWithLanguages.txt" `
                -Destination "$ResultWithLanguages.txt" `
                -Force `
                -WarningAction SilentlyContinue            
        }

        #Join-NAVApplicationObjectFile -Source "$ResultWithLanguages\*.txt" -Destination "$ResultWithLanguages.txt"
        Split-navApplicationObjectFile -Source "$ResultWithLanguages.txt" -Destination "$ResultWithLanguages"
        
    } -ArgumentList $UpgradeSettings

} -ArgumentList $UpgradeSettings, $ContainerName
