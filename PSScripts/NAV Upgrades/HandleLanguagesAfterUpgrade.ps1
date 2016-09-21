$ResultFolder = 'C:\_Workingfolder\Upgrade_NH\MergeResult_ChangedOnly - Result'
$ResultFileName = join-path $WorkingFolder 'Result.txt'
$LanguageFolder = (join-path $WorkingFolder 'Languages')
$LanguageFileFilter = "$($(get-item $ModifiedObjects).basename)*.*"
$LanguageJoinedFileName = join-path $WorkingFolder 'CustomLanguages.txt'
$LanguageResultFileName = $ResultFileName = join-path $WorkingFolder 'Result_WithLanguages.txt'


Join-NAVApplicationObjectFile -Source $ResultFolder -Destination $ResultFileName -Force

if (Test-Path $LanguageFolder){
    $LanguageFiles = Get-ChildItem $LanguageFolder -Filter $LanguageFileFilter
    
    $LanguageFiles | Join-NAVApplicationObjectLanguageFile -Destination $LanguageJoinedFileName 
    
    Import-NAVApplicationObjectLanguage -Source $ResultFileName -LanguagePath $LanguageJoinedFileName -Destination $LanguageResultFileName
}