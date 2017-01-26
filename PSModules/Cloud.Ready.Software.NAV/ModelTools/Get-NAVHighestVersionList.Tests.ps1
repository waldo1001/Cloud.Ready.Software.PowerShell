$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$SystemUnderTest = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$Here\$SystemUnderTest"

Describe 'Get-NAVHighestVersionList' {
    It 'Handles simple versions correctly' {
        Get-NAVHighestVersionList -VersionList1 'NAVW18.00' -VersionList2 'NAVW16.00' -Prefix 'NAVW1' | Should Be 'NAVW18.00'
    }

    It 'Handles missing parameter values correctly' {
        Get-NavHighestVersionList -VersionList1 'NAVW18.00' -Prefix 'NAVW1' | Should Be 'NAVW18.00'
        Get-NavHighestVersionList -VersionList2 'NAVW19.00' -Prefix 'NAVW1' | Should Be 'NAVW19.00'
        Get-NavHighestVersionList -VersionList1 'NAVW11.10' | Should Be 'NAVW11.10'
        Get-NavHighestVersionList | Should Be ''
    }

    It 'Handles double digit version numbers correctly' {
        Get-NAVHighestVersionList -VersionList1 'NAVW110.00' -VersionList2 'NAVW17.10.00.37563' -Prefix 'NAVW1' | Should Be 'NAVW110.00'
    }

    It 'Shows warning if one or more version lists have a different prefix' {
        (Get-NAVHighestVersionList -VersionList1 'NAVW18.00' -VersionList2 'NAVNA9.00' -Prefix 'NAVW1' 3>&1) -match 'Versionlists are probably too unstructured to compare' | Should Be $true
        (Get-NAVHighestVersionList -VersionList1 'NAVW18.00' -VersionList2 'NAVBE9.00' -Prefix 'NAVNL' 3>&1) -match 'Versionlists are probably too unstructured to compare' | Should Be $true
    }
}