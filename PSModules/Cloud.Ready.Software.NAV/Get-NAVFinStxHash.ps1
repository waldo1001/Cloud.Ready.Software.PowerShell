Function Get-NAVFinStxHash{
    if (!$NAVIde){
        write-error 'Module "Microsoft.Dynamics.Nav.Model.Tools" has not been loaded.  Please load this module.'
        break
    }

    $finstx = $NavIde -replace 'finsql.exe', 'fin.stx'

    $finstxLines = @()
    get-content $finstx | foreach{
        $Regex = '(\d+-\d+)-.+: (.+)'
        $MatchedRegEx = [regex]::Match($_, $Regex)

        if ($MatchedRegEx.Success){
            #$Line = New-Object PSObject
            #$Line | Add-Member -MemberType NoteProperty -Name 'Token' -Value $MatchedRegEx.Groups[1].Value
            #$Line | Add-Member -MemberType NoteProperty -Name 'Value' -Value $MatchedRegEx.Groups[2].Value
            #$finstxlines += $Line

            $finstxlines += @{$MatchedRegEx.Groups[1].Value = $MatchedRegEx.Groups[2].Value}
        }
    }

    return $finstxLines
}