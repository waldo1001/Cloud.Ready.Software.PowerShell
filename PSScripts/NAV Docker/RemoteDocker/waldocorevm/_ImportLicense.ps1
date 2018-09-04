<# Import-NavContainerLicense -containerName devpreview -licenseFile 'C:\ProgramData\NavContainerHelper\CRS - 6743401 NAV2018 W1.flf'

Import-NAVServerLicense -ServerInstance NAV -LicenseFile 'C:\ProgramData\NavContainerHelper\5230132_003 and 004 IFACTO_NAV2018_BELGIUM_2018 07 30.flf'

 #>
. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$LicenseFile = "C:\Users\ericw\Dropbox (Personal)\Dynamics NAV\Licenses\5230132_003 and 004 IFACTO_NAV2018_BELGIUM_2018 07 30.flf"
$ContainerName = 'navserver'

Import-RDHNAVContainerLicense `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $ContainerName `
    -LicenseFile $LicenseFile `
    -Verbose