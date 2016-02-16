function Release-NAVVersionList
{
    <#
    .Synopsis
       Arrange NAV VersionList and provide a new ProductVersion
    .DESCRIPTION
       <TODO: why would I need it?>
    .NOTES
       <TODO: Some tips>
    .PREREQUISITES
       <TODO: like positioning the prompt and such>
    #>
    param (
        [String]$VersionList,
        [String]$ProductVersion, 
        [String[]]$Versionprefix
    )


    $allVersions = @() + $VersionList.Split(',')
    $allversions += $ProductVersion
    
    $mergedversions = @()
    foreach ($prefix in $Versionprefix)
    {
        #add the "highest" version that starts with the prefix
        $mergedversions += $allVersions | where { $_.StartsWith($prefix) } | Sort | select -last 1

        # remove all prefixed versions
        $allversions = $allVersions.Where({ !$_.StartsWith($prefix) })
    }

    # return a ,-delimited string consiting of the "hightest" prefixed versions and any other non-prefixed versions
    $mergedVersions = $mergedVersions -join ','
    $mergedVersions
}