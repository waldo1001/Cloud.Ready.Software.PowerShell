. (Join-path $PSScriptRoot '_Settings.ps1')

$Translationsfiles = Get-ChildItem "C:\temp\Distri\Translations"


foreach ($Translationsfile in $Translationsfiles) {
    $filename = $Translationsfile.Name
    $appname = $filename.Substring(7, $filename.IndexOf('.')-7)

    $target = join-path $Workspace "$appname\App\Translations"
    if(get-item $target) {
        Move-Item -Path $Translationsfile.FullName -Destination $target -Force 
    }else{
        Write-Error 'fout'
    }
}