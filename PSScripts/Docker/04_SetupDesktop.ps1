$hostName = "navserver"
$containerName = "navserver"
$DockerDir = "C:\_Docker"

function Log([string]$line, [string]$color = "Gray") { ("<font color=""$color"">" + [DateTime]::Now.ToString([System.Globalization.DateTimeFormatInfo]::CurrentInfo.ShortTimePattern.replace(":mm",":mm:ss")) + " $line</font>") | Add-Content -Path "$DockerDir\status.txt"; Write-Host -ForegroundColor $color $line }

function DownloadFile([string]$sourceUrl, [string]$destinationFile)
{
    Log("Downloading '$sourceUrl'")
    Remove-Item -Path $destinationFile -Force -ErrorAction Ignore
    (New-Object System.Net.WebClient).DownloadFile($sourceUrl, $destinationFile)
}

function New-DesktopShortcut([string]$Name, [string]$TargetPath, [string]$WorkingDirectory = "", [string]$IconLocation = "", [string]$Arguments = "")
{
    $filename = "C:\Users\Public\Desktop\$Name.lnk"
    if (!(Test-Path -Path $filename)) {
        $Shell =  New-object -comobject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($filename)
        $Shortcut.TargetPath = $TargetPath
        if (!$WorkingDirectory) {
            $WorkingDirectory = Split-Path $TargetPath
        }
        $Shortcut.WorkingDirectory = $WorkingDirectory
        if ($Arguments) {
            $Shortcut.Arguments = $Arguments
        }
        if ($IconLocation) {
            $Shortcut.IconLocation = $IconLocation
        }
        $Shortcut.save()
    }
}

# Enable File Download in IE
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1803" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1803" -Value 0

# Enable Font Download in IE
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1604" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1604" -Value 0

$Folder = "C:\DOWNLOAD\VSCode"
$Filename = "$Folder\VSCodeSetup-stable.exe"
New-Item $Folder -itemtype directory -ErrorAction ignore | Out-Null
if (!(Test-Path $Filename)) {
    DownloadFile -SourceUrl "https://go.microsoft.com/fwlink/?LinkID=623230" -destinationFile $Filename
}

Log "Installing Visual Studio Code"
$setupParameters = “/VerySilent /CloseApplications /NoCancel /LoadInf=""$DockerDir\vscode.inf"" /MERGETASKS=!runcode"
Start-Process -FilePath $Filename -WorkingDirectory $Folder -ArgumentList $setupParameters -Wait -Passthru | Out-Null

Log "Download samples"
$Folder = "C:\DOWNLOAD"
$Filename = "$Folder\samples.zip"
New-Item $folder -ItemType Directory -ErrorAction Ignore
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://www.github.com/Microsoft/AL/archive/master.zip", $filename)
Remove-Item -Path "$folder\AL-master" -Force -Recurse -ErrorAction Ignore | Out-null
[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.Filesystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($filename, $folder)
Copy-Item -Path "$folder\AL-master\*" -Destination $PSScriptRoot -Recurse -Force -ErrorAction Ignore

<#
$alFolder = "C:\Users\$([Environment]::UserName)\Documents\AL"
Remove-Item -Path "$alFolder\Samples" -Recurse -Force -ErrorAction Ignore | Out-Null
New-Item -Path "$alFolder\Samples" -ItemType Directory -Force -ErrorAction Ignore | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot "Samples\*") -Destination "$alFolder\Samples" -Recurse -ErrorAction Ignore
#>


$vsixFileName = (Get-Item "$DockerDir\*.vsix").FullName
if ($vsixFileName -ne "") {

    Log "Installing .vsix"
    $code = "C:\Program Files (x86)\Microsoft VS Code\bin\Code.cmd"
    & $code @('--install-extension', $VsixFileName) | Out-Null

    $username = [Environment]::UserName
    if (Test-Path -path "c:\Users\Default\.vscode" -PathType Container -ErrorAction Ignore) {
        if (!(Test-Path -path "c:\Users\$username\.vscode" -PathType Container -ErrorAction Ignore)) {
            Copy-Item -Path "c:\Users\Default\.vscode" -Destination "c:\Users\$username\" -Recurse -Force -ErrorAction Ignore
        }
    }
}

Log "Creating Desktop Shortcuts"
New-DesktopShortcut -Name "Landing Page"                 -TargetPath "http://${hostname}"                             -IconLocation "C:\Program Files\Internet Explorer\iexplore.exe, 3"
New-DesktopShortcut -Name "Visual Studio Code"           -TargetPath "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
New-DesktopShortcut -Name "Web Client"                   -TargetPath "https://${hostname}/NAV/"                             -IconLocation "C:\Program Files\Internet Explorer\iexplore.exe, 3"
New-DesktopShortcut -Name "Container Command Prompt"     -TargetPath "CMD.EXE"                                             -IconLocation "C:\Program Files\Docker\docker.exe, 0" -Arguments "/C docker.exe exec -it $containerName cmd"
New-DesktopShortcut -Name "NAV Container PowerShell Prompt"  -TargetPath "CMD.EXE"                                             -IconLocation "C:\Program Files\Docker\docker.exe, 0" -Arguments "/C docker.exe exec -it $containerName powershell -noexit c:\run\prompt.ps1"

Log "Cleanup"
Remove-Item "C:\DOWNLOAD\AL-master" -Recurse -Force -ErrorAction Ignore
Remove-Item "C:\DOWNLOAD\VSCode" -Recurse -Force -ErrorAction Ignore
Remove-Item "C:\DOWNLOAD\samples.zip" -Force -ErrorAction Ignore

# Remove Scheduled Task
if (Get-ScheduledTask -TaskName setupScript -ErrorAction Ignore) {
    schtasks /DELETE /TN setupScript /F | Out-Null
}

#Start-Process "http://${hostname}"
#Start-Process "http://aka.ms/moderndevtools"

Log "Container output:"
docker logs navserver | % { log $_ }

