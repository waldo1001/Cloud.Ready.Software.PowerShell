$CompareResult = Compare-NAVApplicationObject -OriginalPath .\Distri91.txt -ModifiedPath .\iFactoBaseDEV.txt -DeltaPath .\Deltas\

Split-NAVApplicationObjectFile -Source .\iFactoBaseDEV.txt -Destination .\iFactoBaseDEV\ -Force
Split-NAVApplicationObjectFile -Source .\Distri91.txt -Destination .\Distri91\ -Force

$OriginalObjects = Get-NAVApplicationObjectProperty -Source .\Distri91\*.txt 
$ModifiedObjects = Get-NAVApplicationObjectProperty -Source .\iFactoBaseDEV\*.txt 

foreach($ModifiedObject in $ModifiedObjects) {
    $Result = ($CompareResult | where {(($_.ObjectType -eq $ModifiedObject.ObjectType) -and ($_.Id -eq $ModifiedObject.Id))}).CompareResult
    if ($Result -eq 'Identical') {
        $OriginalObject = $OriginalObjects | where {(($_.ObjectType -eq $ModifiedObject.ObjectType) -and ($_.Id -eq $ModifiedObject.Id))}
        if ($OriginalObject.VersionList -ne $ModifiedObject.VersionList) {
            "$($ModifiedObject.ObjectType)$($ModifiedObject.Id) $($ModifiedObject.VersionList) --> $($OriginalObject.VersionList)"
            Set-NAVApplicationObjectProperty `                -TargetPath $ModifiedObject.PSPath `                -VersionListProperty $OriginalObject.VersionList `                -DateTimeProperty "$($OriginalObject.Date) $($OriginalObject.Time)"                 
        }
    }
}

Join-NAVApplicationObjectFile -Source .\iFactoBaseDEV\*.txt -Destination .\iFactoBaseDEV_updated.txt