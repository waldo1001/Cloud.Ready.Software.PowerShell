. (Join-path $PSScriptRoot '_Settings.ps1')

$Translationsfiles = Get-ChildItem "C:\Temp\translations\Translations Distri translated"


foreach ($Translationsfile in $Translationsfiles) {
    $filename = $Translationsfile.Name
    $appname = $filename.Substring(7, $filename.IndexOf('.') - 7)

    $target = (Get-ChildItem -Recurse -Path $Workspace -Filter "*$($appname)*.xlf")[0]
    # $target = join-path $Workspace "$appname\App\Translations"
    if ($target) {
        Move-Item -Path $Translationsfile.FullName -Destination $target.Directory -Force 
    }
    else {
        Write-Error "fout $target"
    }
}