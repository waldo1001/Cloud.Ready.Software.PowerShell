

$Files = get-childitem D:\==WORKINGFOLDER -File -Recurse | where LastWriteTime -ge (Get-date -Day 1 -Month 1 -Year 2013 -Hour 00 -Minute 00)

foreach ($File in $Files) {
    $DestinationDir = $File.Directory -replace 'D:\\==WORKINGFOLDER','C:\_Workingfolder'
    if (-not (test-path $DestinationDir)) {New-Item -Path $DestinationDir -ItemType directory}
    Copy-Item -Path $File.FullName -Destination (Join-Path $DestinationDir $File.Name) -Recurse 
}