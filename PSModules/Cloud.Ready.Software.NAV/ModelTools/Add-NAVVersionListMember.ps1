function Add-NAVVersionListMember {
    param (
        [Parameter(Mandatory=$true)]
        [String]$VersionList,
        [Parameter(Mandatory=$true)]
        [String]$AddVersionList
    )

    if ([String]::IsNullOrEmpty($VersionList)) {
        return $AddVersionList
        break
    }
    
    if ([String]::IsNullOrEmpty($AddVersionList)) {
        return $VersionList
        break
    }
    
    return "$($VersionList),$AddVersionList" 
}