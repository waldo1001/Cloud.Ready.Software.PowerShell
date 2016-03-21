function Export-NAVApplicationObjectDevelopmentLanguage{
    param(
        [String] $Source,
        [String] $DestinationXML,
        [String] $DevelopmentLanguageId,
        [String] $WorkingFolder
    )
    
    $DevLanguage = 
        Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $DevelopmentLanguageId `
            -Destination (Join-Path $workingfolder "DEVLanguage.txt") `
            -Force `            -PassThru `            -DevelopmentLanguageId $DevelopmentLanguageId

    $Dictionary = @()
    $i = 0
    $count = ($DevLanguage.TranslateLines | measure).Count
    foreach ($Entry in $DevLanguage.TranslateLines){
        $i++
        write-progress -Activity 'Building Dictionary' -Status "$($i)/$($count)" -PercentComplete (($i / $count)*100)

        $DictEntry = @{$Entry.Key=$Entry.Value}
        $Dictionary += $DictEntry
    }

    if ($DestinationXML) {
        $null = $Dictionary | Export-Clixml -Path $DestinationXML
    }

    return $Dictionary
}

