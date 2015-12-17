. (join-path $PSScriptRoot 'Set-UpgradeSettings.ps1')

Enable-NAVServerInstancePortSharing -ServerInstance 'DynamicsNAV90'
New-NAVEnvironment -ServerInstance 'Distriplus90' -BackupFile C:\_Workingfolder\CustomerDBs\Distriplus90.bak
Enable-NAVServerInstancePortSharing -ServerInstance 'Distriplus90'

Import-NAVServerLicense -LicenseFile $NAVLicense -ServerInstance 'Distriplus90'
Set-NAVServerInstance -ServerInstance 'Distriplus90' -Restart

#Create Product Environment
#Remove-NAVEnvironment -ServerInstance 'ProductDEV'
#Copy-NAVEnvironment -ServerInstance 'DynamicsNAV80' -ToServerInstance 'ProductDEV'


#Copy-NAVEnvironment -ServerInstance $CopyFromServerInstance -ToServerInstance $ProductServerInstance -ErrorAction Stop
#write-warning 'TODO: import customizations'