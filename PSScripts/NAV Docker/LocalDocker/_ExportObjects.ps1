. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'navserver'
$Path = 'C:\Temp\'
$filter = 'Id=3'


$Result = Export-NCHNAVApplicationObjects `
            -ContainerName $Containername `
            -filter $filter 


move-item -Path $Result -Destination (Join-Path -Path $Path -ChildPath ([io.path]::getFilename($result))) -Force

start $Path
