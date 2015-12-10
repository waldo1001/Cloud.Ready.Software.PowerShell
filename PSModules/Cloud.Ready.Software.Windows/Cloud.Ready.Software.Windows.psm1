Get-Item $PSScriptRoot | Get-ChildItem -Recurse -Include '*.ps1' |  Sort Name | foreach {
    Write-Verbose "Loading $($_.Name)"  
    . $_.fullname
}

Export-ModuleMember -Function *