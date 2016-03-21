function Get-NAVApplicationObjectLanguageKeyObject{
    param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [String] $Key
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
        $RegEx = '(P\d+)-A'
        $MatchedRegEx = [regex]::Match($Key, $regex)
        $PropertyTypeID = $MatchedRegEx.Groups.Item(1).value   
        $PropertyType = $PropertyTypeID
        Switch ($PropertyTypeID){
            'P18490' {$PropertyType = 'Requestfilterheading'}
            'P26171' {$PropertyType = 'Textconstant'}
            'P8630' {$PropertyType = 'PageName'}
            'P8631' {$PropertyType = 'ToolTip'}
            'P8632' {$PropertyType = 'OptionString'}
            'P8629' {
                $PropertyType = 'ObjectName'
                if ($ObjectType = 'Table'){$PropertyType = 'TableField'}
                if ($ObjectType = 'Page'){
                    $RegEx = 'C\d+.+P8629-.+'
                    $MatchedRegEx = [regex]::Match($Key, $regex)
                    if ($MatchedRegEx.Success){$PropertyType = 'TextBox'}                     
                    $RegEx = '-P55242-'
                    $MatchedRegEx = [regex]::Match($Key, $regex)
                    if ($MatchedRegEx.Success){$PropertyType = 'Action'}                                    
                }
            }
        }

        #Language
        $RegEx = '-A(\d+)-'
        $MatchedRegEx = [regex]::Match($Key, $regex)
        $LanguageID = $MatchedRegEx.Groups.Item(1).value   
        $LanguageCode = Convert-NAVApplicationObjectLanguageCode -Convert $LanguageID
       

        $MyObject = New-Object PSObject
        $MyObject | Add-Member -MemberType NoteProperty -Name 'Key' -Value $Key
        $MyObject | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value $ObjectType
        $MyObject | Add-Member -MemberType NoteProperty -Name 'Id' -Value $Id
        $MyObject | Add-Member -MemberType NoteProperty -Name 'PropertyType' -Value $PropertyType
        $MyObject | Add-Member -MemberType NoteProperty -Name 'LCID' -Value $LanguageID
        $MyObject | Add-Member -MemberType NoteProperty -Name 'LanguageCode' -Value $LanguageCode           
    
        return $MyObject
    }  
}
