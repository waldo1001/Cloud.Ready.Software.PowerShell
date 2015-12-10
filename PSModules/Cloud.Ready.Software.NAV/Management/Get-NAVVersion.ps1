function Get-NAVVersion {
    $file = Get-ChildItem -Path c:\ -Recurse -Filter 'Microsoft.Dynamics.NAV*.dll' | select -First 1
    if(!$file){
        Write-Error 'NAV not found on this system!'
    } else {
        [System.Diagnostics.FileVersionInfo]::GetVersionInfo($file.FullName).FileVersion
    }
    
}
