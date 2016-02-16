# Import settings
. (Join-Path $PSScriptRoot 'Set-NAVExtensionSettings.ps1')

#Create NAVX
$StartedDateTime = Get-Date

Write-Host 'Creating NavX Package.. ' -ForegroundColor Green
$AppPackage = Create-NAVXFromDB `
                    -AppName $AppName `                    -BuildFolder $NavAppWorkingFolder `
                    -OriginalServerInstance $OriginalServerInstance `
                    -ModifiedServerInstance $ModifiedServerInstance `
                    -InitialVersion $InitialAppVersion `
                    -AppDescription $AppDescription `
                    -AppPublisher $AppPublisher `
                    -PermissionSetId $AppName `
                    -ErrorAction Stop

# Install NAV Package
Write-Host 'Installing NavX Package.. ' -ForegroundColor Green
$InstalledApp = Deploy-NAVXPackage `
                    -PackageFile $AppPackage.PackageFile `
                    -ServerInstance $TargetServerInstance `
                    -Tenant $TargetTenant `
                    -Force `
                    -Verbose

$StoppedDateTime = Get-Date
Write-Host 'Total Duration' ([Math]::Round(($StoppedDateTime - $StartedDateTime).TotalSeconds)) 'seconds' -ForegroundColor Green

#Open RTC Test-environment
$CompanyName = (Get-NAVCompany -ServerInstance $TargetServerInstance -Tenant $TargetTenant)[0].CompanyName
Start-NAVWindowsClient -ServerName ([net.dns]::GetHostName()) -ServerInstance $TargetServerInstance -Companyname $CompanyName
