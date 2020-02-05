$alc = get-childitem -Path "$env:USERPROFILE\.vscode\extensions" -Recurse alc.exe | select -First 1
$target = "C:\_Source\DistriApps\BASE\App"

Set-location $target
& $($alc.FullName) /project:$target

