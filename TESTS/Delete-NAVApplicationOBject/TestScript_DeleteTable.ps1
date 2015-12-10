

Delete-NAVApplicationObject -DatabaseServer ([net.dns]::GetHostName()) -DatabaseName $Databasename -LogPath .\DeleteLog -Filter 'Type=Table;Id=67890' -SynchronizeSchemaChanges Force -NavServerInstance $ServerInstance 

