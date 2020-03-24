
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bccurrent'

Clean-NCHCustomNAVApps -ContainerName $Containername 

Get-NCHCustomNAVApps -ContainerName $Containername