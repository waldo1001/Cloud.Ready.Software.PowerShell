Invoke-ScriptInBcContainer -containerName PerfTest -scriptblock {
    Get-navappinfo bc | where Publisher -eq 'waldo' | Uninstall-NAVApp -verbose
    Get-navappinfo bc | where Publisher -eq 'waldo' | Unpublish-NAVApp -verbose
}