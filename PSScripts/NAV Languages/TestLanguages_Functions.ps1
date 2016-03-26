$workingfolder = 'C:\_WorkingFolder\Testperformance\'
$Source = Join-Path $workingfolder 'ALL_CFMD.txt'
$CurrentLanguage = 'NLB','FRB','ENU'
$DevelopmentLanguageId = 'ENU'

cd $workingfolder
$time1 =Measure-Command -Expression {    $DevelopmentDictionary1 =         $CurrentLanguage |             Export-NAVApplicationObjectLanguageHash `                    -Source $Source `                    -DestinationXML 'Dictionary.xml' `                    -DevelopmentLanguageId $DevelopmentLanguageId `                    -WorkingFolder $workingfolder }$time2 =Measure-Command -Expression {    $DevelopmentDictionary2 =         Export-NAVApplicationObjectLanguageHash `            -Source $Source `            -LanguageId $CurrentLanguage `            -DestinationXML 'Dictionary.xml' `            -DevelopmentLanguageId $DevelopmentLanguageId `            -WorkingFolder $workingfolder }      
$DevelopmentDictionary1.Count
$DevelopmentDictionary2.Count

$time1.TotalMilliseconds
$Time2.TotalMilliseconds

break
    
<#
$DevelopmentDictionary =
    Get-NAVApplicationObjectDevelopmentLanguage `        -SourceXML .\DevLanguage.xml
#>

break

$MyTranslations = 
    Get-NAVApplicationObjectLanguage `        -Source $Source `        -WorkingFolder $workingfolder `        -LanguageId $CurrentLanguage `        -DevelopmentTranslations $DevelopmentDictionary$MyTranslations | ogv$MyTranslations | Export-Csv -Path (Join-Path $workingfolder 'Translations.csv')start $workingfolder