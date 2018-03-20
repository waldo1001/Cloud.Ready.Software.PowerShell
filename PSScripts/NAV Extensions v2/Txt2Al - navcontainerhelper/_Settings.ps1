
$DockerHost = 'waldocorevm'
$DockerHostUseSSL = $false
$DockerHostSessionOption = New-PSSessionOption

if (-not ($DockerHostCredentials)){
    $UserName = 'administrator'
    $DockerHostCredentials = Get-Credential -UserName $UserName -Message "Please provide password for $UserName"
}