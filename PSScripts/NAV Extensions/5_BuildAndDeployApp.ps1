# Import settings
. (Join-Path $PSScriptRoot '_Settings.ps1')

#Create NAVX
$StartedDateTime = Get-Date

Write-Host 'Creating NavX Package.. ' -ForegroundColor Green
$AppPackage = Create-NAVXFromDB `
                    -AppName $AppName `
                    -BuildFolder $NavAppWorkingFolder `
                    -OriginalServerInstance $OriginalServerInstance `
                    -ModifiedServerInstance $ModifiedServerInstance `
                    -InitialVersion $InitialAppVersion `
                    -AppDescription $AppDescription `
                    -AppPublisher $AppPublisher `
                    -PermissionSetId $AppName `
                    -BackupPath $BackupPath `
                    -ErrorAction Stop `
                    -IncludeFilesInNavApp $IncludeFilesInNavApp `
                    -WebServicePrefix $WebServicePrefix `
                    -Logo $Logo.FullName

# Install NAV Package
Write-Host 'Installing NavX Package.. ' -ForegroundColor Green
$InstalledApp = Deploy-NAVXPackage `
                    -PackageFile $AppPackage.PackageFile `
                    -ServerInstance $TargetServerInstance `
                    -Tenant $TargetTenant `
                    -Force `
                    -Verbose `
                    -SkipVerification

$StoppedDateTime = Get-Date
Write-Host 'Total Duration' ([Math]::Round(($StoppedDateTime - $StartedDateTime).TotalSeconds)) 'seconds' -ForegroundColor Green

#Open RTC Test-environment
if ($TestWindowsClient) {Start-NAVWindowsClient -ServerInstance $TargetServerInstance}
if ($TestWebClient)     {Start-NAVWebClient -WebServerInstance $TargetServerInstance -WebClientType Web}
if ($TestTabletClient)  {Start-NAVWebClient -WebServerInstance $TargetServerInstance -WebClientType Tablet}
if ($TestPhoneClient)   {Start-NAVWebClient -WebServerInstance $TargetServerInstance -WebClientType Phone}