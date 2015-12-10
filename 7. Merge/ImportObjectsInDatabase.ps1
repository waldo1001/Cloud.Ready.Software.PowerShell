$DefaultServerInstance = 'DynamicsNAV90'
$DatabaseName = 'Distri2016CTP20'
$ObjectPath = 'C:\_Merge\Distri82ToNAV2016CTP20\Result_Filtered'

Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1'
import-module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'

Get-ChildItem (join-path $PSScriptRoot  '..\PSFunctions\*.ps1') -Recurse -File | foreach {import-module $_.FullName}

Enable-NAVServerInstancePortSharing -ServiceInstance $DefaultServerInstance

$ServerInstanceExists = Get-NAVServerInstance -ServerInstance $DatabaseName
if ($ServerInstanceExists) {
    write-warning "$DatabaseName already exists and needs to be removed first!"
    Remove-NAVEnvironment -ServerInstance $DatabaseName -ErrorAction Stop -Confirm:$true
}

$CurrentServerInstance = Get-NAVServerInstance2 -ServerInstance $DefaultServerInstance

$BackupFile = Backup-SQLDatabaseToFile -DatabaseServer $CurrentServerInstance.DatabaseServer -DatabaseName $CurrentServerInstance.DatabaseName -ErrorAction Stop

New-NAVEnvironment -ServerInstance $DatabaseName -BackupFile $BackupFile -ErrorAction Stop

$BackupFile | Remove-Item 

get-navserverinstance | get-navtenant | select ServerInstance, Id, State | Format-Table -AutoSize

Import-NAVApplicationObject -Path "$ObjectPath\*.txt" -DatabaseName $DatabaseName -LogPath "$ObjectPath\ImportLog" -ImportAction Overwrite

#Remove-NAVEnvironment -ServerInstance $DatabaseName
