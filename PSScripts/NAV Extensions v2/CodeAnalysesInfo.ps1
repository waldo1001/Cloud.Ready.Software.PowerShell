Get-ChildItem "$env:USERPROFILE\.vscode\extensions" -Recurse -Filter "*.Nav.*Cop.dll" |
    Get-AlCodeCopInfo |
    ogv             