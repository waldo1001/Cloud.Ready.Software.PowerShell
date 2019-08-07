$AppFile = get-item "C:\Users\ericw\Documents\AL\ALProject26\Default publisher_ALProject26_1.0.0.1.app"
$ContainerName = 'bcdaily'

#Script
$DestinationInContainer = Join-Path "C:\ProgramData\NavContainerHelper" $AppFile.Name
$AppFile | Copy-Item -Destination $DestinationInContainer

Upgrade-NCHNAVApp `
    -ContainerName $ContainerName `
    -Path $DestinationInContainer 


# Publish-BCContainerApp `
#     -containerName $ContainerName `
#     -appFile $AppFile `
#     -skipVerification `
    
