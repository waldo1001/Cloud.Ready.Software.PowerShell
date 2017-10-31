#Mostly from Freddy's scripts.. thanks, man!

$Folder = "C:\_Installs"
$Filename = "$Folder\VSCodeSetup-stable.exe"
$VSIXfolder = join-path $PSScriptRoot 'VSIX'


$codeCmd = "C:\Program Files\Microsoft VS Code\bin\Code.cmd"
$codeExe = "C:\Program Files\Microsoft VS Code\Code.exe"

#Download
New-Item $Folder -itemtype directory -ErrorAction ignore | Out-Null
if (!(Test-Path $Filename)) {
    $sourceUrl = "https://go.microsoft.com/fwlink/?Linkid=852157"

    # Due to a bug in v16 - take v15
    #$sourceUrl = "https://vscode-update.azurewebsites.net/1.15.1/win32-x64/stable"
    #$disableVsCodeUpdate = $true

    Write-Host "Downloading VSCode" -ForegroundColor Green
    Invoke-WebRequest -Uri $sourceUrl -OutFile $Filename
}

#Install
Write-Host "Installing Visual Studio Code (this should only take a minute)" -ForegroundColor Green
$setupParameters = '/VerySilent /CloseApplications /NoCancel /LoadInf=""c:\demo\vscode.inf"" /MERGETASKS=!runcode'
Start-Process -FilePath $Filename -WorkingDirectory $Folder -ArgumentList $setupParameters -Wait -Passthru | Out-Null

#Show extensions
Write-Host "Opening webpages of recommended extensions...  " -ForegroundColor Green
Write-Host "  waldo.crs-al-language-extension  " -ForegroundColor Gray
start "https://marketplace.visualstudio.com/items?itemName=waldo.crs-al-language-extension"
Write-Host "  mssql.mssql  " -ForegroundColor Gray
start "https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql"
Write-Host "  humao.rest-client  " -ForegroundColor Gray
start "https://marketplace.visualstudio.com/items?itemName=humao.rest-client"
Write-Host "  vscode.PowerShell  " -ForegroundColor Gray
start "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell"
       https://marketplace.visualstudio.com/items?itemName=vscode.PowerShell

#Install VSIX
$VSIXFiles = Get-ChildItem $VSIXfolder
foreach ($VSIXFile in $VSIXFiles)
{
    $vsixFileName = $VSIXFile.FullName
    if ($vsixFileName -ne "") {

        Write-Host "Installing $vsixFileName" -ForegroundColor Green
        & $codeCmd @('--install-extension', $VsixFileName) | Out-Null

        $username = [Environment]::UserName
        if (Test-Path -path "c:\Users\Default\.vscode" -PathType Container -ErrorAction Ignore) {
            if (!(Test-Path -path "c:\Users\$username\.vscode" -PathType Container -ErrorAction Ignore)) {
                Copy-Item -Path "c:\Users\Default\.vscode" -Destination "c:\Users\$username\" -Recurse -Force -ErrorAction Ignore
            }
        }
    }   
}


#Install Git
Write-Host "Installing Git" -ForegroundColor Green
$GitExec = "$Folder\Git.exe"
$GitDownloadURL = 'https://github.com/git-for-windows/git/releases/download/v2.14.3.windows.1/Git-2.14.3-64-bit.exe'

Invoke-WebRequest $GitDownloadURL -OutFile $GitExec
Write-Host "Installing $GitExec" -ForegroundColor Green
Start-Process -FilePath $GitExec -ArgumentList "/VERYSILENT"
