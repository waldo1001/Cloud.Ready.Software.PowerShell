$AppFile = get-item "C:\Users\ericw\Documents\AL\ALProject26\Default publisher_ALProject26_1.0.0.0.app"
$AppFile = get-item "C:\Users\ericw\Documents\AL\ALProject27\Default publisher_ALProject27_1.0.0.0.app"
$ContainerName = 'bcdaily'

#Script
$DestinationInContainer = Join-Path "C:\ProgramData\NavContainerHelper" $AppFile.Name
$AppFile | Copy-Item -Destination $DestinationInContainer

Install-NCHNavApp `
    -ContainerName $ContainerName `
    -Path $DestinationInContainer `
    -DoNotDeleteAppFile:$true
