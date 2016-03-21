$workingfolder = 'C:\_Workingfolder\LanguageStuff'
$Source = Join-Path $workingfolder 'ALL_CFMD.txt'
$CurrentLanguage = 'NLB'
$DevelopmentLanguageId = 'ENU'

cd $workingfolder

$DevelopmentDictionary =    Export-NAVApplicationObjectDevelopmentLanguage `            -Source $Source `            -DestinationXML 'DevLanguage.xml' `            -DevelopmentLanguageId $DevelopmentLanguageId `            -WorkingFolder $workingfolder

<#
$DevelopmentDictionary =
    Get-NAVApplicationObjectDevelopmentLanguage `        -SourceXML .\DevLanguage.xml
#>

$MyTranslations = 
    Get-NAVApplicationObjectLanguage `        -Source $Source `        -WorkingFolder $workingfolder `        -LanguageId $CurrentLanguage `        -DevelopmentTranslations $DevelopmentDictionary$MyTranslations | ogv$MyTranslations | Export-Csv -Path (Join-Path $workingfolder 'Translations.csv')start $workingfolder