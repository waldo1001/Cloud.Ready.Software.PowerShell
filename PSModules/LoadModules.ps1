write-host 'Loading Cloud Ready Software modules...'

Write-Progress -Activity 'Loading Cloud.Ready.Software.NAV ...' -PercentComplete 12
Import-module (join-path $PSScriptRoot 'Cloud.Ready.Software.NAV\Cloud.Ready.Software.NAV.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module Cloud.Ready.Software.NAV -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading Cloud.Ready.Software.PowerShell ...' -PercentComplete 37
Import-module (join-path $PSScriptRoot 'Cloud.Ready.Software.PowerShell\Cloud.Ready.Software.PowerShell.psm1') -DisableNameChecking -Force  -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module Cloud.Ready.Software.PowerShell -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading Cloud.Ready.Software.SQL ...' -PercentComplete 62
Import-module (join-path $PSScriptRoot 'Cloud.Ready.Software.SQL\Cloud.Ready.Software.SQL.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module Cloud.Ready.Software.SQL -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

Write-Progress -Activity 'Loading Cloud.Ready.Software.Windows ...' -PercentComplete 87
Import-module (join-path $PSScriptRoot 'Cloud.Ready.Software.Windows\Cloud.Ready.Software.Windows.psm1') -DisableNameChecking -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
Import-module Cloud.Ready.Software.Windows -Force -WarningAction SilentlyContinue  -ErrorAction SilentlyContinue

Clear-host
write-host -ForegroundColor Yellow 'Get-Command -Module ''Cloud.Ready.Software.*'''
get-command -Module 'Cloud.Ready.Software.*'
