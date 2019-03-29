
. '.\_Settings.ps1'

$RemotePath = $UpgradeSettings.ObjectLibrary

If (!(Test-Path $RemotePath)) {
    Write-Host -ForegroundColor Gray "  Creating folder $RemotePath on Docker Host"
    New-Item -Path $RemotePath -ItemType Directory -Force
}

function CopyAndUnzipFile{
    param(
        [string] $ZippedFileName,
        [string] $RemotePath
    )

    $ZippedDestinationFileName = Join-Path $RemotePath (get-item $ZippedFileName).Name
    Copy-Item $ZippedFileName -Destination $ZippedDestinationFileName -Recurse -Force
    Unblock-File $ZippedDestinationFileName
    Expand-Archive $ZippedDestinationFileName $RemotePath -Force
    Remove-Item $ZippedDestinationFileName -Force
}

#Original
$File = $UpgradeSettings.LocalOriginalFile
if ([io.Path]::GetExtension($File) -eq '.zip') {^
    CopyAndUnzipFile -ZippedFileName $File -RemotePath $RemotePath
} else {
    Copy-Item $File -Destination $RemotePath -Recurse -Force
}

#Modified
$File = $UpgradeSettings.LocalModifiedFile
if ([io.Path]::GetExtension($File) -eq '.zip') {^
    CopyAndUnzipFile -ZippedFileName $File -RemotePath $RemotePath
} else {
    Copy-Item $File -Destination $RemotePath -Recurse -Force
}

#Target
$File = $UpgradeSettings.LocalTargetFile
if ([io.Path]::GetExtension($File) -eq '.zip') {^
    CopyAndUnzipFile -ZippedFileName $File -RemotePath $RemotePath
} else {
    Copy-Item $File -Destination $RemotePath -Recurse -Force
}
