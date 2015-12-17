#Export Languages with missing laguages
$Languages    = "ENU","NLB","FRB"
$Exportfile   = "ExportedTranslation.txt" 
$SortOnObject = $true

cd 'C:\_PowerShell\Test_Languages\Export Languages with missing languages'

Export-NAVApplicationObjectLanguage `
            -Source .\NoLanguages.txt `
            -LanguageId $Languages `
            -Destination (Join-Path "." $Exportfile) `
            -Force

if ($SortOnObject) {
    Get-Content (Join-Path "." $Exportfile) | sort | Set-Content (Join-Path "." $Exportfile) -Force
}

. (Join-Path "." $Exportfile) 