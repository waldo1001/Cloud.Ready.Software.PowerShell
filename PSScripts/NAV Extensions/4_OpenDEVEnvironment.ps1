# Import settings
. (Join-Path $PSScriptRoot '_Settings.ps1') -ErrorAction Stop

#Load modules (to be able to run this script as stand-alone as well)
Import-Module (Get-ChildItem 'C:\Program Files' -Recurse | where FullName -like '*NAVAdminTool.ps1*').FullName
Import-Module (Get-ChildItem 'C:\Program Files (x86)' -Recurse | where FullName -like '*Microsoft.Dynamics.Nav.Model.Tools.psd1').FullName

Start-NAVIdeClient $ModifiedServerInstance

<#
start-navwindowsclient $ModifiedServerInstance
#>