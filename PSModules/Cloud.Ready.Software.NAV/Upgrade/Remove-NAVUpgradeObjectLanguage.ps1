Function Remove-NAVUpgradeObjectLanguage {
    [CmdLetBinding()]
    param(
        [String] $Source,
        [String] $WorkingFolder,
        [String[]] $Languages, 
        [ValidateSet('ASCII', 'BigEndianUnicode', 'Default', 'OEM', 'Unicode', 'UTF32', 'UTF7', 'UTF8')]
        [String] $Encoding = 'OEM'
    )
    
    $FileObject = get-item $Source -ErrorAction Stop
    $ObjectsWithoutLanguages = (join-path $WorkingFolder "$($FileObject.BaseName)_WithoutLanguages.txt")
    $LanguagesFolder = (Join-Path $WorkingFolder 'Languages')

    write-host "Removing languages ($($Languages -join ', ')) from $Source" -ForegroundColor Green

    if (!(Test-Path $LanguagesFolder)) {
        $null = New-Item -Path $LanguagesFolder -ItemType directory
    }

    foreach ($Language in $Languages) {
        $LanguageFile = (Join-Path $LanguagesFolder "$($FileObject.BaseName)_$($Language).txt")

        Export-NAVApplicationObjectLanguage `
            -Source $Source `
            -Destination $LanguageFile `
            -LanguageId $Language `
            -Encoding $Encoding
    }
    
    Remove-NAVApplicationObjectLanguage `
        -Source $Source `
        -Destination $ObjectsWithoutLanguages `
        -LanguageId $Languages    

        
    return $ObjectsWithoutLanguages    
}