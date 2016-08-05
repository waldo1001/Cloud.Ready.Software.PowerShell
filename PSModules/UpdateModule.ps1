Remove-Item $profile.AllUsersCurrentHost -Force -ErrorAction SilentlyContinue


. (Join-Path $PSScriptRoot 'UnInstallModule.ps1')

. (Join-Path $PSScriptRoot 'InstallModule.ps1')
. (Join-Path $PSScriptRoot 'CreateProfileInISE.ps1')