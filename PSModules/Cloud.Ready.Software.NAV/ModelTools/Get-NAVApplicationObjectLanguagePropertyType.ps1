function Get-NAVApplicationObjectLanguagePropertyType {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [String] $Key,
        [Parameter(Mandatory=$True)]
        [Object] $FinStxHash
    )
    process{        
        $RegEx = 'P(\d+)'
        $MatchedRegEx = [regex]::Matches($Key,$Regex)
        foreach($Match in $MatchedRegEx){
            $Property = $Match.Groups[1].Value
        
            $HexToken = [Convert]::ToString($Property, 16)
            $StringToken1 = ([convert]::ToString([Convert]::ToInt32($HexToken.Substring(0,$HexToken.Length-2),16))).PadLeft(5,'0')
            $StringToken2 = ([convert]::ToString([Convert]::ToInt32($HexToken.Substring($HexToken.Length-2,2),16))).PadLeft(5,'0')
            $StringToken = "$($StringToken1)-$($StringToken2)"

            $FinStxHash.$stringToken
        }

    }
    
}