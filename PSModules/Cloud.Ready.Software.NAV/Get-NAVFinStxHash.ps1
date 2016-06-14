Function Get-NAVFinStxHash{
    if (!$NAVIde){
        $finstx = (Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV" -Recurse | where Name -like fin.stx).FullName
        if (!$finstx){
            write-error 'Module "Microsoft.Dynamics.Nav.Model.Tools" has not been loaded.  Please load this module.'
            break
        }
    } else {
        $finstx = $NavIde -replace 'finsql.exe', 'fin.stx'
    }

    $finstxLines = @()
    get-content $finstx | foreach{
        $Regex = '(\d+-\d+)-.+: (.+)'
        $MatchedRegEx = [regex]::Match($_, $Regex)

        if ($MatchedRegEx.Success){
            $finstxlines += @{$MatchedRegEx.Groups[1].Value = $MatchedRegEx.Groups[2].Value}
        }
    }

    return $finstxLines
}