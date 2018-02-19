. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$session = New-PSSession `
    -ComputerName $DockerHost `
    -Credential $DockerHostCredentials `
    -UseSSL:$DockerHostUseSSL `
    -SessionOption $DockerHostSessionOption

Invoke-Command -Session $session -ScriptBlock {
    Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\CRS.NavContainerHelperExtension' -Force -Recurse
}

Remove-PSSession -Session $session