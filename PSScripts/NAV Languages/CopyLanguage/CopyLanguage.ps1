#Copy language (e.g. from NLD to NLB)
$Source       = ".\NoLanguages.txt"
$FromLanguage = "ENU"
$ToLanguage   = "NLB"
$Destination  = "Result.txt"

cd C:\_PowerShell\Test_Languages\CopyLanguage

$FromTranslations = (Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $FromLanguage `
            -Destination (Join-Path "." "$FromLanguage.txt") `
            -Force -PassThru).TranslateLines.'<>3__source'.TranslateLines

$ToTranslations = (Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $ToLanguage `
            -Destination (Join-Path "." "$ToLanguage.txt") `
            -Force -PassThru).TranslateLines.'<>3__source'.TranslateLines

$i = 0
for ($i = 0; $i -le ($FromTranslations.Count - 1) ; $i++)
{ 
    $ToTranslations[$i].Value = $FromTranslations[$i].Value
}

$ToTranslations.Line | Set-Content -Path (Join-Path "." $Destination)
. (Join-Path "." $Destination)

