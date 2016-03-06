function Remove-NAVVersionListMember {
    param (
        [Parameter(Mandatory=$true)]
        [String]$VersionList,
        [Parameter(Mandatory=$true)]
        [String]$RemoveVersionList
    )

    $allVersions = @() + $VersionList.Split(',')
    
    $NewVersionList = @()

    $allVersions = @() + $Versionlist.Split(',')
    $allVersions | foreach {
        if ($_ -ine $RemoveVersionList){
            $NewVersionList += $_
        }
    }    
    
    return $NewVersionList -join ','

}