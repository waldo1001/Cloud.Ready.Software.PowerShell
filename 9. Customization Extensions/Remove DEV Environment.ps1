. (Join-Path $PSScriptRoot 'Set-NAVExtensionSettings.ps1') -ErrorAction Stop

$DEVServerInstanceObject = get-navserverinstance3 -serverinstance $ModifiedServerInstance

#Export-NAVApplicationObject -Filter 'Modified=1' -DatabaseServer $DEVServerInstanceObject.DatabaseServer -DatabaseName $DEVServerInstanceObject.DatabaseName -Path $BackupDEVChangesfile -Force -ErrorAction Stop

Remove-NAVEnvironment -ServerInstance $OriginalServerInstance 
Remove-NAVEnvironment -ServerInstance $ModifiedServerInstance -BackupModifiedObjectsPath $BackupModifiedObjectsPath
Remove-NAVEnvironment -ServerInstance $TargetServerInstance
