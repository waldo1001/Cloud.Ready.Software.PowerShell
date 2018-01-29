<#
enter-pssession waldocorevm
#>

$AppFile = "C:\ProgramData\NavContainerHelper\Demo\ManageAppUpgradeDemo\Cloud Ready Software GmbH_BookShelf_5.0.0.0.app"

$Session = Get-NavContainerSession -containerName navserver
Invoke-Command -Session $Session -ScriptBlock {
    param($AppFile)
    $AppInfo = Get-NAVAppInfo -path $AppFile

    Publish-NAVApp -ServerInstance NAV -Path $AppFile -SkipVerification
    Sync-NAVApp -ServerInstance NAV -Name $AppInfo.Name -Version $AppInfo.Version 
    Start-NAVAppDataUpgrade -ServerInstance NAV -Name $AppInfo.Name -Version $AppInfo.Version
} -ArgumentList $AppFile
