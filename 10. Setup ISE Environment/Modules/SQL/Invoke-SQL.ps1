#Source: http://stackoverflow.com/questions/8423541/how-do-you-run-a-sql-server-query-from-powershell
function Invoke-SQL {
    param(
        [string] $DatabaseServer = ".",
        [string] $DatabaseName = "Master",
        [string] $SQLCommand = $(throw "Please specify a query.")
      )

    $connectionString = "Data Source=$DatabaseServer; Integrated Security=SSPI; Initial Catalog=$DatabaseName"

    write-Host -ForegroundColor Green "Invoke-SQL :'$SQLCommand'"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $dataSet.Tables

}