#. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$containerName = 'bccurrent'
$extensionStartId = '50001'
$Path = 'C:\temp\AL'
$filter = 'Id="42|46|43|47|6630|6631|50|54|51|55|49|97|67|66"'
# $filter = "Id=11315"
# $filter = 'Id="507|9303|509|9310"'
$filter = 'Id="134332|134338|137212"'

$result = Export-NCHNAVApplicationObjectsAsAL `
    -ContainerName $containerName `
    -filter $filter `
    -extensionStartId $extensionStartId `
    -DestinationPath $Path 

# Get-ChildItem "C:\ProgramData\navcontainerhelper\Extensions\$containerName\Export-NAVALfromNAVApplicationObject\AL" | 
#     Move-Item -Destination $Path -Force 

start $Path
