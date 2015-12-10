function Remove-NAVVersionFromVersionList {
  <#
  .SYNOPSIS
  Removes a part of the Version List 
  .DESCRIPTION
  Removes a part of the Version List 
  .EXAMPLE
  To remove the prefixes 'I' and 'M' from VersionList 'NAVW17.0,NAVBE7.0,NAVWD7.1,I8.0,M20156'
    Remove-NAVVersionFromVersionList -VersionList 'NAVW17.0,NAVBE7.0,NAVWD7.1,I8.0,M20156' -RemovePrefixes 'I','M'
  Result:
    NAVW17.0,NAVBE7.0,NAVWD7.1  
  .PARAMETER VersionList
  The VersionList that needs to be modified
  .PARAMETER RemovePrefixes
  The prefixes that need to disappear from the VersionList
  #>
    param(
        [String] $VersionList,
        [String[]] $RemovePrefixes    
    )
    $Versions = $VersionList.Split(',')
    foreach($RemovePrefix in $RemovePrefixes){
        $Versions = $Versions | where {-not($_.StartsWith($RemovePrefix))}
    }
    
    $NewVersionList = $Versions -join ','
    $NewVersionList
}

