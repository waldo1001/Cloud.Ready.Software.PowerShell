Function Get-NAVApplicationObjectLanguage {
    param(
        [String] $Source,
        [String] $WorkingFolder,
        [String[]] $LanguageId,
        [Object] $DevelopmentTranslations,
        [Switch] $NotOnlyMissingTranslations
    )

    $WorkingFolder = Join-Path $WorkingFolder 'GetNAVApplicationObjectLanguage'
    If (!(Test-Path $WorkingFolder)){$null = New-Item -Path $WorkingFolder -ItemType directory}

    $LanguageLegend = @()
    $Translations = @()
    
    $Translations = Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $LanguageId `
            -Destination (Join-Path $workingfolder "Translations.txt") `
            -Force `            -PassThru `            -DevelopmentLanguageId $DevelopmentLanguageId

    $FinStxHash = Get-NAVFinStxHash

    if($DevelopmentTranslations){
        $KeyObject = Get-NAVApplicationObjectLanguageKeyObject -Key $DevelopmentTranslations[0].Keys[0] -FinStxHash $FinStxHash
        $DEVLanguageCode = $KeyObject.LCID
        $DEVLanguageCode = $KeyObject.LanguageCode 
    }

    if (-not ($NotOnlyMissingTranslations)){
        $TranslateLines = $Translations.TranslateLines | Where Value -eq ''
    } else {
        $TranslateLines = $Translations.TranslateLines
    }

    $FinalResults = @()
    $Results = @()
    $i = 0
    $Count = ($TranslateLines | Measure).Count
    foreach($TranslateLine in $TranslateLines){
        $KeyObject = Get-NAVApplicationObjectLanguageKeyObject -Key $TranslateLine.Key -FinStxHash $FinStxHash

        $i++
        Write-Progress -Activity 'Analyzing...' -Status "$($KeyObject.ObjectType) $($KeyObject.Id)" -PercentComplete (($i / $Count) * 100)
               
        $Result = New-Object PSObject
        $Result | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $KeyObject.ObjectType
        $result | Add-Member -MemberType NoteProperty -Name 'Id' -Value $KeyObject.Id
        $result | Add-Member -MemberType NoteProperty -Name 'LCID' -Value $KeyObject.LCID
        $result | Add-Member -MemberType NoteProperty -Name 'LanguageCode' -Value $KeyObject.LanguageCode
        $result | Add-Member -MemberType NoteProperty -Name 'PropertyType' -Value $KeyObject.PropertyType
        $result | Add-Member -MemberType NoteProperty -Name 'Key' -Value $TranslateLine.Key
        $result | Add-Member -MemberType NoteProperty -Name 'Line' -Value $TranslateLine.Line
        $result | Add-Member -MemberType NoteProperty -Name 'Value' -Value $TranslateLine.Value

        $TranslationsMissing = $false
        foreach($language in $LanguageId){            
            $CurrLang = $DevelopmentTranslations.(Convert-NAVApplicationObjectLanguageKey -KeyToConvert $TranslateLine.Key -ToLanguage $language)
            $result | Add-Member -MemberType NoteProperty -Name $language -Value $CurrLang
            if (([string]::IsNullOrEmpty($CurrLang))){
                $TranslationsMissing=$true
            }
        }

        if (($KeyObject.propertyType -eq 'ActionList/CaptionML') -or (!$TranslationsMissing)){
            $KeyObject.TranslationNecessary = $false
        }
                
        $result | Add-Member -MemberType NoteProperty -Name 'TranslationNecessary' -Value $KeyObject.TranslationNecessary

        $Results += $Result

        if (($i%1000) -eq 0){
            $FinalResults += $Results
            $Results = @()
        }
        
    }
    $FinalResults += $Results

    return $FinalResults
}