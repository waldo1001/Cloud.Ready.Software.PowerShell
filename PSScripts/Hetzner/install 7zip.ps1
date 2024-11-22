$TempFile = join-path $env:temp '7zip.exe'
Invoke-WebRequest -uri "https://www.7-zip.org/a/7z1900-x64.exe" -OutFile $TempFile

cmd /c "(start /wait $((get-item $TempFile).FullName) /S)"
