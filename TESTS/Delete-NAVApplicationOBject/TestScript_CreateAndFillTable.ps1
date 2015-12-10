$ServerInstance = 'NAV2015_CU1'
$Databasename   = 'NAV2015_CU1'

Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1'
import-module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'

Import-NAVApplicationObject -Path .\TestObjects.fob -DatabaseName $Databasename -DatabaseServer ([net.dns]::GetHostName()) -LogPath .\Log -ImportAction Overwrite -SynchronizeSchemaChanges Force
Get-NAVCompany -ServerInstance $ServerInstance |
    foreach {Invoke-NAVCodeunit -CodeunitId 67890 -ServerInstance $ServerInstance -CompanyName $_.CompanyName}
