#Test Merge NAVVersionList


$OrigVersionlist = 'NAVW17.10.00.37563,NAVBE7.10.00.37563'
$ModVersionList  = 'NAVW17.10.00.37563,NAVBE7.10.00.37563,I7.4,M22344,M65877,I8.0'
$TgtVersionList  = 'NAVW110.00,NAVBE10.00'
$MyVersionprefix = 'NAVW1', 'NAVBE', 'I'

 
Merge-NAVVersionList `
    -OriginalVersionList $OrigVersionlist `
    -ModifiedVersionList $ModVersionList `    -TargetVersionList $TgtVersionList `
    -Versionprefix $MyVersionprefix



Get-NAVHighestVersionList `    -VersionList1 'NAVW17.10.00.37563' `    -VersionList2 'NAVW110.00' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'NAVW110.00' `    -VersionList2 'NAVW17.10.00.37563' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 '' `    -VersionList2 'NAVW17.10.00.37563' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'NAVW17.10.00.37563' `    -VersionList2 '' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'test' `    -VersionList2 'anothertest' `    -Prefix 'completelyNotwhatsinversionlist'Get-NAVHighestVersionList `    -VersionList1 'NAVW110.00' `    -VersionList2 'anothertest' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'anothertest' `    -VersionList2 'NAVW110.00' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'NAVW17.10.00.37563' `    -VersionList2 'NAVW17.10.00.37564' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'NAVW17.10.00.37564' `    -VersionList2 'NAVW17.10.00.37563' `    -Prefix 'NAVW1'Get-NAVHighestVersionList `    -VersionList1 'NAVW17.10.00.37564' `    -VersionList2 'NAVW17.10.01.37563' `    -Prefix 'NAVW1'