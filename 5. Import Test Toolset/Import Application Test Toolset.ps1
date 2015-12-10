$PathToDVD = 'D:\'
$ServerInstance = 'DynamicsNAV90'

$Config = Get-NAVServerConfiguration2 -ServerInstance $ServerInstance

$Database = ($Config | where key -eq Databasename).Value

if (test-path (join-path $PSScriptRoot "Log")) { Remove-Item -Path (join-path $PSScriptRoot "Log") -force -recurse}

$ConfirmPreference = 'None'
get-childitem (join-path $PathToDVD 'TestToolKit') | foreach {
    Import-NAVApplicationObject -Path $_.FullName -DatabaseName $Database -DatabaseServer ([Net.dns]::GetHostName()) -LogPath (join-path $PSScriptRoot "Log") -ImportAction Overwrite -SynchronizeSchemaChanges Force 
}

Import-NAVApplicationObject -Path (Join-Path $PSScriptRoot 'ImportAllTestCodeunits.fob') -DatabaseName $Database -DatabaseServer ([Net.dns]::GetHostName()) -LogPath (join-path $PSScriptRoot "Log") -ImportAction Overwrite -SynchronizeSchemaChanges Force
$CompanyName = (Get-NAVCompany -ServerInstance $ServerInstance)[0].CompanyName
if ([string]::IsNullOrEmpty($CompanyName)) {
    $CompanyName = (Get-NAVCompany -ServerInstance $ServerInstance).CompanyName    
}
Invoke-NAVCodeunit -ServerInstance $ServerInstance -CompanyName $CompanyName -CodeunitId 54944  

Delete-NAVApplicationObject -DatabaseName $Database -DatabaseServer ([net.dns]::gethostname()) -LogPath (join-path $PSScriptRoot "Log") -Filter 'Type=Codeunit;ID=54944' 