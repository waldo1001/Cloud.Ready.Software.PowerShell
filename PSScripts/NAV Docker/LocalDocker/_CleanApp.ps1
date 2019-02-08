
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bcdaily'

Clean-NCHCustomNAVApps -ContainerName $Containername 

Get-NCHCustomNAVApps -ContainerName $Containername