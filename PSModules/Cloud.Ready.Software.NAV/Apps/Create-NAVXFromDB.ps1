function Create-NAVXFromDB
{
    [CmdLetBinding()]
    param(
        [string] $AppName,
        [String] $AppPublisher,
        [String] $AppDescription,
        [string] $BuildFolder,
        [string] $OriginalServerInstance,
        [string] $ModifiedServerInstance,
        [String] $InitialVersion = '1.0.0.0',
        [String] $PermissionSetId='',
        [String] $BackupPath,
        [String] $Dependencies)

    # Set Variables
    $BuildFolder = (join-path $BuildFolder 'Create-NAVXFromDB')

    $navAppManifestFile = (join-path $BuildFolder "$($AppName).xml")

    New-Item -ItemType Directory -Force -Path $BuildFolder | Out-Null

    $packageFolder = Join-Path -Path $BuildFolder -ChildPath 'Packages'
    $packageFolder = New-Item -ItemType Directory -Force -Path $packageFolder
    
    # Update or Create Manifest
    Write-Host -Foregroundcolor Green 'Setup App-Manifest... '
    
    if (Test-Path -Path $navAppManifestFile){
        $MyNewManifest = Get-NAVAppManifest -Path $navAppManifestFile
    }
    if ($MyNewManifest -eq $null)
    {
        Write-Host -Foregroundcolor Green 'Create APP Package'
        $MyNewManifest = Create-NAVAppPackage -AppName $AppName -BuildFolder $BuildFolder -Version $InitialVersion -Publisher $AppPublisher -Description $AppDescription
    } else {
        Write-Host -Foregroundcolor Green 'Update APP Package'
        $newAppVersion = $MyNewManifest.AppVersion.Major.ToString() + '.' + $MyNewManifest.AppVersion.Minor.ToString() + '.' + $MyNewManifest.AppVersion.Build.ToString() + '.' + ($MyNewManifest.AppVersion.Revision + 1).ToString()
        $MyNewManifest = Set-NAVAppManifest `                            -Manifest $MyNewManifest `                            -Version $newAppVersion `                            -PrivacyStatement 'http://www.waldo.Be' `                            -Eula 'http://www.waldo.Be' `                            -Help 'http://www.waldo.Be' `                            -Url 'http://www.waldo.Be' `                            -Dependencies $Dependencies
    }

    New-NAVAppManifestFile -Path $navAppManifestFile -Manifest $MyNewManifest -Force 
        
    # Extract Applications and Create Deltas
    Write-Host -Foregroundcolor Green "Starting to create deltas between $OriginalServerInstance and $ModifiedServerInstance ..."
    $navAppFileDirectory = Create-NAVAppFiles -OriginalServerInstance $OriginalServerInstance -ModifiedServerInstance $ModifiedServerInstance -BuildPath $BuildFolder -PermissionSetId $PermissionSetId

    # Create NavX Package
    $navAppPackageFile = $AppName + '_v' + $MyNewManifest.AppVersion.ToString() + '.navx'
    $navAppPackageFile = Join-Path -Path $packageFolder -ChildPath $navAppPackageFile
    if (Test-Path -Path $navAppPackageFile)
    {
        Remove-item $navAppPackageFile
    }
    Write-Host -Foregroundcolor Green "DeltaDir: $navAppFileDirectory"    
    $AppPackage = New-NAVAppPackage -Manifest $MyNewManifest -SourcePath $navAppFileDirectory -Path $navAppPackageFile -PassThru 
    Write-Host -Foregroundcolor Green "NavX Package File: $navAppPackageFile"
    
    if ($BackupPath){
        $null = Copy-Item -Path $PackageFolder -Destination $BackupPath -Recurse -Force    
    }

    [hashtable]$Return = @{} 
    $Return.Manifest = $MyNewManifest
    $Return.PackageFile = $navAppPackageFile
    return $Return
}