function Get-ObjectFromJSON {
    param(
        [String] $Path 
    )

    Write-Verbose "Function: Get-SCMObjectFromJSON"
    $Object = (Get-Content $Path) -Join "`n" | ConvertFrom-Json

    return $Object
}
