$AppFile = get-item "C:\Users\ericw\Documents\AL\ALProject14\Default publisher_ALProject14_1.0.0.0.app"
$ContainerName = 'bcdaily'

#Script
$DestinationInContainer = Join-Path "C:\ProgramData\NavContainerHelper" $AppFile.Name
$AppFile | Copy-Item -Destination $DestinationInContainer

Install-NCHNavApp `
    -ContainerName $ContainerName `
    -Path $DestinationInContainer `
    #-DoNotDeleteAppFile:$false
