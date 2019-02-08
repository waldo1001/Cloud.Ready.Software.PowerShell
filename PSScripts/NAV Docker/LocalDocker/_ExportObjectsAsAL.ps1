. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$containerName = 'bcdaily'
$extensionStartId = '50001'
$Path = 'C:\temp\AL'
$filter = 'Id=32'


$result = Export-NCHNAVApplicationObjectsAsAL `
    -ContainerName $containerName `
    -filter $filter `
    -extensionStartId $extensionStartId `
    -DestinationPath $Path 

# Get-ChildItem "C:\ProgramData\navcontainerhelper\Extensions\$containerName\Export-NAVALfromNAVApplicationObject\AL" | 
#     Move-Item -Destination $Path -Force 

start $Path
