function Convert-NAVApplicationObjectLanguageKey {
    param(
        [String] $KeyToConvert,
        [String] $ToLanguage
    )

    $KeyObject = Get-NAVApplicationObjectLanguageKeyObject -Key $KeyToConvert

    $CurrentLanguage = $KeyObject.LCID
    $KeyToConvert -replace "-A$($CurrentLanguage)-", "-A$(Convert-NAVApplicationObjectLanguageCode -Convert $ToLanguage)-"
}
