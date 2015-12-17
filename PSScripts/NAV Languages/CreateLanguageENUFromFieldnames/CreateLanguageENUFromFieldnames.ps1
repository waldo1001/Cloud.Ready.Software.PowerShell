#Create ENU Language From Fieldnames
$Source   = ".\Objects.txt"


cd C:\_PowerShell\Test_Languages\CreateLanguageENUFromFieldnames

(Export-NAVApplicationObjectLanguage `
                -Source $Source `
                -Destination (Join-Path "." "ENU.txt") `
                -LanguageId ENU `
                -DevelopmentLanguageId ENU `
                -Force -PassThru).TranslateLines.'<>3__source'.TranslateLines
