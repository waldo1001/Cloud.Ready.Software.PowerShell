. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$TestTool = "C:\ProgramData\NavContainerHelper\PS Test Tool.fob"

Import-NAVApplicationObject2 -Path $TestTool -ServerInstance NAV -LogPath "C:\ProgramData\navcontainerhelper"