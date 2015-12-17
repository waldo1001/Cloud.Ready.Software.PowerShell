$LicenseFile = Get-ChildItem "$PSScriptRoot\5230132_003 and 004 IFACTO_NAV2015_BELGIUM_2014 10 02.flf"

if ($LicenseFile.Count -gt 1) {
    Write-Error "$($LicenseFile.Count) licenses found on $PSScriptRoot"
    break
}

Get-NAVServerInstance | Import-NAVServerLicense -LicenseFile $LicenseFile.FullName
Get-NAVServerInstance | Set-NAVServerInstance -Restart