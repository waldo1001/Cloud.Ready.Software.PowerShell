function Get-NAVApplicationObjectLanguageKeyObject{
    param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [String] $Key,
        [Parameter(Mandatory=$false)]
        [Object] $FinStxHash
    )

    process{
        #ObjectType
        switch ($Key[0]){
            'T'{$ObjectType = 'Table'}
            'F'{$ObjectType = 'Form'}
            'R'{$ObjectType = 'Report'}
            'D'{$ObjectType = 'Dataport'}
            'C'{$ObjectType = 'Codeunit'}
            'X'{$ObjectType = 'XMLport'}
            'M'{$ObjectType = 'MenuSuite'}
            'N'{$ObjectType = 'Page'}
            'Q'{$ObjectType = 'Query'} 
        }

        #ObjectID
        $RegEx = '(\d+)-'
        $MatchedRegEx = [regex]::Match($Key, $regex)
        $Id = $MatchedRegEx.Groups.Item(1).value   

        #PropertyType
        if ($FinStxHash){
            $PropertyTypes =                 Get-NAVApplicationObjectLanguagePropertyType `                    -Key $Key `                    -FinStxHash $FinStxHash
        } else {
            $PropertyTypes = 'Unknown'
        }
        #Language
        $RegEx = '-A(\d+)-'
        $MatchedRegEx = [regex]::Match($Key, $regex)
        $LanguageID = $MatchedRegEx.Groups.Item(1).value   
        $LanguageCode = Convert-NAVApplicationObjectLanguageCode -Convert $LanguageID
       
        #TranslationNecessary
        $TranslationNecessary = $true
        if(($PropertyTypes -join '/').Contains('ToolTip')){
            $TranslationNecessary = $false
        }

        $MyObject = New-Object PSObject
        $MyObject | Add-Member -MemberType NoteProperty -Name 'Key' -Value $Key
        $MyObject | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $ObjectType
        $MyObject | Add-Member -MemberType NoteProperty -Name 'Id' -Value $Id
        $MyObject | Add-Member -MemberType NoteProperty -Name 'PropertyType' -Value ($PropertyTypes -join '/')
        $MyObject | Add-Member -MemberType NoteProperty -Name 'TranslationNecessary' -Value $TranslationNecessary
        $MyObject | Add-Member -MemberType NoteProperty -Name 'LCID' -Value $LanguageID
        $MyObject | Add-Member -MemberType NoteProperty -Name 'LanguageCode' -Value $LanguageCode           
    
        return $MyObject
    }  
}
