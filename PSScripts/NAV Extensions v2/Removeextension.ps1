import-module 'C:\Program Files\Microsoft Dynamics NAV\100\Service\NavAdminTool.ps1'

$AppJson = Get-ObjectFromJSON '.\app.json' 

Get-NAVAppInfo -ServerInstance navision_main -Tenant default | 
    where Publisher -eq $AppJson.publisher |
        Uninstall-NAVApp

Get-NAVAppInfo -ServerInstance navision_main | 
    where Publisher -like $AppJson.publisher |
        Unpublish-NAVApp