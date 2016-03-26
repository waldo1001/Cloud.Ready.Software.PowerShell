function Export-NAVApplicationObjectLanguageHash{
    param(
        [String] $Source,
        [String] $DestinationXML,
        [Parameter(ValueFromPipeline=$true)]
        [String[]] $LanguageId,
        [String] $DevelopmentLanguageId,
        [String] $WorkingFolder
    )
    Begin{
        $TempTextFile = (Join-Path $workingfolder 'ExportNAVApplicationObjectLanguageHash.txt')
    
        $Translations = 
            Export-NAVApplicationObjectLanguage `
                -Source $Source `
                -Destination $TempTextFile `
                -Force `                -PassThru `                -DevelopmentLanguageId $DevelopmentLanguageId
    }
    process{        
<#        $Translations = 
            Export-NAVApplicationObjectLanguage `
                -Source $Source `
                -LanguageId $LanguageId `
                -Destination $TempTextFile `
                -Force `                -PassThru `                -DevelopmentLanguageId $DevelopmentLanguageId#>
<#
        if($LanguageId.Count -eq 1){
            $lanuageCode = "-A$(Convert-NAVApplicationObjectLanguageCode $LanguageId)-"                                                                                                 
            $TranslationLines = $Translations.TranslateLines | where Key -like "*$lanuageCode*"
        } else {
            $TranslationLines = $Translations.TranslateLines
        }
#>
    
        $FullDictionary = @()
        foreach($Language in $LanguageId){
            $lanuageCode = "-A$(Convert-NAVApplicationObjectLanguageCode $Language)-"                                                                                                 
            $TranslationLines = $Translations.TranslateLines | where Key -like "*$lanuageCode*"

            $Dictionary = @()
            $i = 0
            $count = ($TranslationLines | measure).Count

            foreach ($Entry in $TranslationLines){
                $i++
                if (($i%100) -eq 0){write-progress -Activity "Building Dictionary for $language" -Status "$($i)/$($count)" -PercentComplete (($i / $count)*100)}

                $DictEntry = @{$Entry.Key=$Entry.Value}
                $Dictionary += $DictEntry
                                
                if (($i%1000) -eq 0){
                    $FullDictionary += $Dictionary
                    $Dictionary = @()            
                }
            }

            $FullDictionary += $Dictionary
        }
        
        if ($DestinationXML) {
            $null = $FullDictionary | Export-Clixml -Path $DestinationXML
        }

        Remove-Item $TempTextFile -Force -ErrorAction SilentlyContinue

        return $FullDictionary
    }
}

