Get-ChildItem "$env:USERPROFILE" -Recurse -Filter "*Cop.dll" |
    Get-AlCodeCopInfo |
        ogv