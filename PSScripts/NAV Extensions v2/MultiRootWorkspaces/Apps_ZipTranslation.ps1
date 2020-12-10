. (Join-path $PSScriptRoot '_Settings.ps1')

Get-ChildItem $Workspace -filter *.xlf -Recurse -Exclude "*TEST*" | 
Compress-Archive -DestinationPath (join-path $Workspace "translation.zip") -Force

start $Workspace