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
                    -IncludeFilesInNavApp $IncludeFilesInNavApp

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
if ($TestRTC)
    {
        $CompanyName = (Get-NAVCompany -ServerInstance $TargetServerInstance -Tenant $TargetTenant)[0].CompanyName
        Start-NAVWindowsClient -ServerName ([net.dns]::GetHostName()) -ServerInstance $TargetServerInstance -Companyname $CompanyName
    }
    
# Open Webclients for manual testing
if ($TestWebClient)
    {
        $URLToOpen = $NavWebClientAddress + "Default.aspx"
        Start-Process -FilePath $URLToOpen
    }
if ($TestTabletClient)
    {
        $URLToOpen = $NavWebClientAddress + "Tablet.aspx"
        Start-Process -FilePath $URLToOpen
    }
if ($TestPhoneClient)
    {
        $URLToOpen = $NavWebClientAddress + "Phone.aspx"
        Start-Process -FilePath $URLToOpen
    }
