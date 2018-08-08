function Get-NAVCodeSnippet {
    Param(
        [System.Collections.Generic.List[String]] $CodeLines,
        [String] $FocusText,
        [int] $NumberOfContextLines,
        [int] $Indent
    )
    $ResultString = @()

    $pos = $CodeLines.FindIndex( { param($m) $m -like "*$($FocusText)*" })    
    #$pos = $CodeLines.IndexOf($CodeLines.Where({$_ -like "*$($FocusText)*"}) ) 
    $Begin = $pos - [math]::Round(($NumberOfContextLines / 2), 1)
    if ($Begin -lt 0) {$Begin = 0}
    $Outputlines = $CodeLines | Select -Skip $Begin -First $NumberOfContextLines
    $EndIncluded = ($Begin + 10) -ge $CodeLines.Count - 1
    $found = $false

    if ($begin -ne 0) {     
        $ResultString += '...'
    }
    foreach ($Outputline in $Outputlines) {            
        if ($Outputline -like "*$($FocusText)*") {            
            $OutputLine = $Outputline + ' <====================='
            $found = $true
        } 
        $ResultString += $Outputline                        
    }  
    if (!$EndIncluded) {   
        $ResultString += '...'
    }

    if ($Indent -gt 0) {
        for ($i = 0; $i -lt $ResultString.Count; $i++) {
            $ResultString[$i] = $ResultString[$i].PadLeft($ResultString[$i].Length + $Indent , ' ')
        }
    }

    if (!$found) {Write-Error "'$($FocusText)' not found!"}

    Return $ResultString
}