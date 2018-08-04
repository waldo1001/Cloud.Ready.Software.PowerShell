. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ModulePath = "$env:USERPROFILE\dropbox\github\Cloud.Ready.Software.PowerShell\PSModules\CRS.NavContainerHelperExtension"

$cs = New-PSSession -ComputerName $DockerHost -UseSSL:$DockerHostUseSSL -Credential $DockerHostCredentials -SessionOption $DockerHostSessionOption

Get-ChildItem $ModulePath | %{
    Copy-Item `        -Path $_.FullName `        -Destination 'C:\Program Files\WindowsPowerShell\Modules\CRS.NavContainerHelperExtension\1.0.1.8' `        -ToSession $cs `        -Force `        -Recurse        }        Remove-PSSession $cs