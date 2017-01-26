function Get-NAVHighestVersionList
{
    param (
        [String]$VersionList1,
        [String]$VersionList2,
        [String]$Prefix
    )
   
    if ([string]::IsNullOrEmpty($Versionlist1)){return $VersionList2}
    if ([string]::IsNullOrEmpty($Versionlist2)){return $VersionList1}

    if ($VersionList1 -eq $VersionList2) {
        return $VersionList1
    }

    try{        
        if ([String]::IsNullOrEmpty($Prefix)) {
            [int[]] $SplitVersionlist1 = $VersionList1.split('.')
            [int[]] $SplitVersionlist2 = $VersionList2.split('.')
        } else {
            [int[]] $SplitVersionlist1 = $VersionList1.Replace($Prefix,'').split('.')
            [int[]] $SplitVersionlist2 = $VersionList2.Replace($Prefix,'').split('.')
        }
    } catch {
        $ReturnVersionList = $VersionList2
        try{
            [int[]] $SplitVersionlist2 = $VersionList2.Replace($Prefix,'').split('.')    
        } Catch {
            $ReturnVersionList = $VersionList1
        }

        $WarningMessage = "`r`nVersionlists are probably too unstructured to compare."
        $WarningMessage += "`r`n    VersionList1  : $VersionList1"
        $WarningMessage += "`r`n    VersionList2  : $VersionList2"
        $WarningMessage += "`r`n    Prefix        : $Prefix"        
        $WarningMessage += "`r`n    Returned value: $ReturnVersionList"
        $WarningMessage += "`r`nNo further action required is this is OK."

         
        Write-Warning -Message $WarningMessage
        return $ReturnVersionList
    }

    $Count = $SplitVersionlist1.Count
    if ($SplitVersionlist2.count -gt $count){
        $Count = $SplitVersionlist2.Count
    }

    $HighestVersionList = ''
    for ($i=0;$i -lt $Count;$i++){
        if ($SplitVersionlist1[$i] -gt $SplitVersionlist2[$i]){
            $HighestVersionList = $VersionList1
        }
        if ($SplitVersionlist2[$i] -gt $SplitVersionlist1[$i]){
            $HighestVersionList = $VersionList2
        }
        if ($HighestVersionList -ne ''){
            $i = $Count
        }
    }

    return $HighestVersionList

}
