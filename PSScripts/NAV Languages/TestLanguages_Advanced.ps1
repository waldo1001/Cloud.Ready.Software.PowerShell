$workingfolder = 'C:\_Workingfolder\LanguageStuff'
$Source = Join-Path $workingfolder 'ALL_CFMD.txt'
$CurrentLanguage = 'NLB'

cd $workingfolder


$Translations = (Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $CurrentLanguage `
            -Destination (Join-Path $workingfolder "$CurrentLanguage.txt") `
            -Force -PassThru).TranslateLines.'<>3__source'.TranslateLines

            
$Translations2 = (Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $CurrentLanguage `
            -Destination (Join-Path $workingfolder "$CurrentLanguage.txt") `
            -Force -PassThru).TranslateLines.'<>3__source'


$Results = @()
foreach($object in $Translations2){
    foreach($line in $object.TranslateLines){
        if ($line.Value -eq ''){
            $LineType = ''
            if ($line.Key.Contains('-P8629-')){$LineType = 'ObjectCaption'}
            $Result = New-Object PSObject
            $Result | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $object.ObjectType
            $result | Add-Member -MemberType NoteProperty -Name 'Id' -Value $object.Id
            $result | Add-Member -MemberType NoteProperty -Name 'LCID' -Value $object.LCID
            $result | Add-Member -MemberType NoteProperty -Name 'Key' -Value $line.Key
            $result | Add-Member -MemberType NoteProperty -Name 'Line' -Value $line.Line
            $result | Add-Member -MemberType NoteProperty -Name 'Value' -Value $line.Value
            $result | Add-Member -MemberType NoteProperty -Name 'LineType' -Value $LineType
            $Results += $Result
        }
    }
}
$Results | ogv


$TestResult = Test-NAVApplicationObjectLanguage -Source $Source -LanguageId $CurrentLanguage -PassThru

$TestResult | measure
$TestResult | get-member

$Results = @()
foreach($object in $TestResult){
    foreach($line in $object.TranslateLines){
        $Result = New-Object PSObject
        $Result | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $object.ObjectType
        $result | Add-Member -MemberType NoteProperty -Name 'Id' -Value $object.Id
        $result | Add-Member -MemberType NoteProperty -Name 'LCID' -Value $object.LCID
        $result | Add-Member -MemberType NoteProperty -Name 'Key' -Value $line.Key
        $result | Add-Member -MemberType NoteProperty -Name 'Line' -Value $line.Line
        $result | Add-Member -MemberType NoteProperty -Name 'Value' -Value $line.Value
        $Results += $Result
    }
}

$Results | ogv
$Results | measure


$Translations | Where Key -like '*-P8629-*' | where Value -eq ''



$Translations3 = Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -LanguageId $CurrentLanguage `
            -Destination (Join-Path $workingfolder "$CurrentLanguage.txt") `
            -Force -PassThru
            
$Translations3.translatelines
$Translations3.translatelines | get-member
$Translations3.Languages | ogv

$Translations3.translatelines | measure
$Translations3.Languages.translatelines | measure


$DevelopmentLanguageId = 'ENU'
$LanguageId = 'NLB'

$Translations = Export-NAVApplicationObjectLanguage `
        -Source $Source `
        -LanguageId $LanguageId `
        -Destination (Join-Path $workingfolder "Translations.txt") `
        -Force `        -PassThru `        -DevelopmentLanguageId $DevelopmentLanguageId


$DevLanguage = Export-NAVApplicationObjectLanguage `
        -Source $Source `
        -LanguageId $DevelopmentLanguageId `
        -Destination (Join-Path $workingfolder "DEVLanguage.txt") `
        -Force `        -PassThru `        -DevelopmentLanguageId $DevelopmentLanguageId

$EmptyLines = $Translations.TranslateLines | where Value -eq '' 
foreach ($emptyLine in $EmptyLines){
    $ENULang = $DevLanguage.TranslateLines | where Key -eq (Convert-NAVApplicationObjectLanguageKey -KeyToConvert $EmptyLine.Key -ToLanguage 'ENU')
    Write-host "$($EmptyLine.Key)" -foregroundcolor Green
    write-host $ENULang -foregroundcolor gray
}
$DevLanguage.TranslateLines.Key | measure


$Dictionary = @()
$i = 0
$count = ($DevLanguage.TranslateLines | measure).Count
foreach ($Entry in $DevLanguage.TranslateLines){
    $i++
    write-progress -Activity 'Building Dictionary' -PercentComplete (($i / $count)*100)

    $DictEntry = @{$Entry.Key=$Entry.Value}
    $Dictionary += $DictEntry
}

$EmptyLines = $Translations.TranslateLines | where Value -eq '' 
foreach ($emptyLine in $EmptyLines){
    $Value = $SecondDictionary.(Convert-NAVApplicationObjectLanguageKey -KeyToConvert $EmptyLine.Key -ToLanguage 'ENU')

    #$ENULang = $DevLanguage.TranslateLines | where Key -eq (Convert-NAVApplicationObjectLanguageKey -KeyToConvert $EmptyLine.Key -ToLanguage 'ENU')
    Write-host "$($EmptyLine.Key)" -foregroundcolor Green
    write-host $Value -foregroundcolor gray
}


$DEVLanguageCode = Get-NAVApplicationObjectLanguageLCID -Key $SecondDictionary[0].Keys[0]
$DEVLanguageCode = Convert-NAVApplicationObjectLanguageCode -Convert $DEVLanguageCode 
$DEVLanguageCode
