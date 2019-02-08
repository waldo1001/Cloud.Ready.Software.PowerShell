. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bconprem'
$Path = 'C:\Temp\'
$filter = ''
$SetCulture = 'nl-BE'

$PSSession = New-PSSession -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption
Invoke-Command -Session $PSSession -ScriptBlock {
    param($Containername, $SetCulture)

    $PSSession = Get-NavContainerSession -containerName $Containername
    Invoke-Command -Session $PSSession -ScriptBlock {
        param($SetCulture)
        Write-Host "Setting culture to $SetCulture"
        Set-Culture  $SetCulture

    } -ArgumentList $SetCulture

} -ArgumentList $Containername, $SetCulture

Remove-PSSession $PSSession

# $PSSession = New-PSSession -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption
# Invoke-Command -Session $PSSession -ScriptBlock {
#     param($Containername, $SetCulture)

#     $PSSession = Get-NavContainerSession -containerName $Containername
#     Invoke-Command -Session $PSSession -ScriptBlock {
#         Get-Culture
#     } 

# } -ArgumentList $Containername, $SetCulture

Export-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $Containername `
    -Path $Path `
    -filter $filter

Start $Path
