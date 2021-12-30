# Install BcContainerHelper (could be you need to run this as Administrator):
# Install-Module BcContainerHelper -force

$ArtifactUrl = 'be' | % { 
        Get-BCArtifactUrl `
            -country $_ `
            -sasToken $SecretSettings.InsiderSASToken `
            -select NextMinor} #Specify exact version you'd like to unpack
# $ArtifactUrl = 'be' | % { Get-BCArtifactUrl -country $_ -select Latest } #Specify exact version you'd like to unpack
$Destination = 'C:\_Source\Microsoft\Artifacts'
$bcartifactsCacheFolder = 'c:\bcartifacts.cache\'
$filter = ''
$exclude = ''
$openInCode = $false

$ArtifactPath = $ArtifactUrl | % { Download-Artifacts -artifactUrl $_ -includePlatform }

foreach ($path in $ArtifactPath) {
    write-host "Handling $($path)" -ForegroundColor Green
    $AllSources = Get-ChildItem -Path $path  -Recurse -Filter "$($filter)*.source.zip" -exclude "$($exclude)"
    $SubFolder = join-path $Destination $path.Substring($bcartifactsCacheFolder.Length)

    foreach ($source in $AllSources) {
        $AppName = $source.Name.Replace('.Source.zip', '')
        $DestinationFolder = join-path $SubFolder $AppName

        if (-not (Test-path $DestinationFolder)) {
            write-host "Extracting $($source.name) to $DestinationFolder" -ForegroundColor Gray
            Expand-Archive -Path $source.FullName -DestinationPath $DestinationFolder -Force
        }
    }
    
    if ($openInCode) {
        code $path
    }


}

start $Destination