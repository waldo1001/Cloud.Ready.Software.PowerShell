#Step 1: create DEV Hash
$AnalyzeLanguages = 'NLB', 'FRB', 'ENU'
$DEVLang = 'ENU'

$DEVHash = 
    Export-NAVApplicationObjectLanguageHash `
        -Source C:\Temp\ObjectsWithLanguages.txt `
        -DestinationXML C:\Temp\DevHash.xml `
        -LanguageId $AnalyzeLanguages `
        -DevelopmentLanguageId $DEVLang `
        -WorkingFolder C:\_WorkingFolder  

$ObjectLanguages = 
    Get-NAVApplicationObjectLanguage `
        -Source C:\Temp\ObjectsWithLanguages.txt `
        -WorkingFolder c:\_WorkingFolder `
        -LanguageId $AnalyzeLanguages `
        -DevelopmentTranslations $DEVHash `
        -NotOnlyMissingTranslations

cls
$ObjectLanguages | ogv
