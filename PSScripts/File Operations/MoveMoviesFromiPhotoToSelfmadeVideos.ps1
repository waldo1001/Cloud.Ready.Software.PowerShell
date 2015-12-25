$SourcePath = get-item '\\waldonas\photo\iPhoto'
$DestinationPath = get-item '\\waldonas\video\Selfmade'

Write-Progress -Activity "Getting all movies from $SourcePath" 
$Movies = Get-ChildItem -Path $SourcePath -Recurse | where Extension -In '.mov','.AVI','.MOV','.mp4','.MPG' 

$Count = $movies.Count
$i = 0
foreach ($Movie in $Movies) {
    $DestinationDir = $Movie.Directory.FullName -replace ($SourcePath.FullName -replace '\\','\\'), $DestinationPath.FullName
    #if (-not (test-path $DestinationDir)) {New-Item -Path $DestinationDir -ItemType directory}  
    
    $i++
    Write-Progress -Activity "Moving $($Movie.FullName) to $DestinationDir" -PercentComplete (($i/$count)*100)

    #Copy-Item -Path $Movie.FullName -Destination (Join-Path $DestinationDir $Movie.Name) -Recurse 

    Write-Host "From: $($Movie.FullName)"
    write-host "To:   $(Join-Path $DestinationDir $Movie.Name)"

    
}
