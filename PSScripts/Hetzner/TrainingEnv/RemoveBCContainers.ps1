Get-BcContainers | % {
    Remove-BcContainer $_
}