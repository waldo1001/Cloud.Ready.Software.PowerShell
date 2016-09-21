$Objects = Get-NAVApplicationObjectProperty -Source C:\_Customers\distri_TestVersionlist.txt 
$VersionListPrefixes = 'NAVW1', 'NAVBE', 'I','Test'

foreach ($Object in $Objects){
    
    $newVersionlist = Merge-NAVVersionList -OriginalVersionList $Object.VersionList -ModifiedVersionList '' -TargetVersionList '' -Versionprefix $VersionListPrefixes
    
    "$($Object.VersionList) --> $newVersionlist"
}
$Object