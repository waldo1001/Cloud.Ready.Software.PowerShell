$target = "C:\_Source\DistriApps\"

Write-Host "Get-AppDependencies" -ForegroundColor Yellow


$Paths = Get-AppDependencies -Path $Target -Type ALFolders

# Get-AppDependencies -Path $Target | ForEach-Object {
#     $_.Path
# }

# Set-location $target
# & $($alc.FullName) /project:$("C:\_Source\DistriApps\BASE\App\") /packagecachepath:"C:\_Source\DistriApps\BASE\App\.alpackages"
# & $($alc.FullName) /help

# $Paths[0].Path



$Paths | % {
    Write-Host -ForegroundColor Green "Compiling $($_.Path )" 
}