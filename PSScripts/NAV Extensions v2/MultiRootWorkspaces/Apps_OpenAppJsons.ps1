. (Join-path $PSScriptRoot '_Settings.ps1')


$Command = "Get-childitem $Workspace\*.* -Recurse -filter ""app.json"" | % {code $('$_')}"
$Command | clip.exe

Write-host "Copied the following command to clipboard:" -ForegroundColor green
Write-host "  $Command" -ForegroundColor Yellow
Write-host "Now past it in the terminal of your Multi-root workspace" -ForegroundColor green