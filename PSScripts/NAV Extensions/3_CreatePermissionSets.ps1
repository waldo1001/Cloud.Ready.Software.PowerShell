$PermissionSets = @()

New-NAVAppPermissionSet `
    -ServerInstance $ModifiedServerInstance `    -AppName $AppName `    -PermissionType Read `    -OnTableIDs 50000

New-NAVAppPermissionSet `
    -ServerInstance $ModifiedServerInstance `    -AppName $AppName `    -PermissionType Write `    -OnTableIDs 50000

<#
List of table you should probably handle!

$Tables = Invoke-NAVSQL -ServerInstance $ModifiedServerInstance -SQLCommand 'select * from Object where Modified=1 and Type=1'
$Tables.ID

#>