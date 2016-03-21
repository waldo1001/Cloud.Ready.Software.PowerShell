function Get-NAVApplicationObjectDevelopmentLanguage{
    param(
        [String] $SourceXML
    )

    $Dictionary = Import-Clixml $SourceXML

    return $Dictionary
}

