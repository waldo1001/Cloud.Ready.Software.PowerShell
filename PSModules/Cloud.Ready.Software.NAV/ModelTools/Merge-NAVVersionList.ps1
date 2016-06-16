function Merge-NAVVersionList
{
    param (
        [String]$OriginalVersionList,
        [String]$ModifiedVersionList,
        [String]$TargetVersionList, 
        [String[]]$Versionprefix
    )

    Write-Verbose "Merging $OriginalVersionList, $ModifiedVersionList, $TargetVersionList"
    $allVersions = @() + $OriginalVersionList.Split(',')
    $allversions += $ModifiedVersionList.Split(',')
    $allversions += $TargetVersionList.Split(',')

    $mergedversions = @()
    foreach ($prefix in $Versionprefix)
    {
        #add the "highest" version that starts with the prefix
        $mergedversions += $allVersions | where { $_.StartsWith($prefix) } | Sort | select -last 1

        # remove all prefixed versions
        $allversions = $allVersions.Where({ !$_.StartsWith($prefix) })
    }

    # return a ,-delimited string consiting of the "hightest" prefixed versions and any other non-prefixed versions
    $mergedversions += $allVersions
    $mergedversions = $mergedversions | ? {$_} #Remove empty
    $Result = $mergedVersions -join ','
    write-verbose "Result $Result"
    $Result
}