Split-NAVApplicationObjectFile -Source C:\_ObjectLibrary\Distri82.txt -Destination C:\_ObjectLibrary\Distri82
Split-NAVApplicationObjectFile -Source C:\_ObjectLibrary\Distri81.txt -Destination C:\_ObjectLibrary\Distri81_Diginet

split-navapplicationobjectfile -source C:\_Workingfolder\_CustomerDBs\Diginet_AfterRemovingToIncrease.txt -Destination C:\_Workingfolder\_CustomerDBs\Diginet_AfterRemovingToIncrease


$ModifiedObjectsFolder = 'C:\_Workingfolder\_CustomerDBs\Diginet_AfterRemovingToIncrease'
$NewOriginalFolder = 'C:\_ObjectLibrary\Distri81_Diginet'
$CopiedOriginalFolder = 'C:\_ObjectLibrary\Distri82'


$ObjectProps = Get-NAVApplicationObjectProperty -Source (join-path $ModifiedObjectsFolder '*.txt')

$ObjectProps | where VersionList -match '8\.2' | Foreach {
    $ObjectFileToCopy = Get-Item $_.FileName
    Copy-Item -Path (Join-Path $CopiedOriginalFolder $objectfiletocopy.Name) -Destination (Join-Path $NewOriginalFolder $objectfiletocopy.Name) -Force
}

Join-NAVApplicationObjectFile -Source $NewOriginalFolder -Destination "$($NewOriginalFolder).txt"
