$finsql = """C:\Program Files (x86)\Microsoft Dynamics NAV\130\RoleTailored Client\finsql.exe"""
$ServerInstance = Get-NAVServerInstanceDetails -ServerInstance nav

cmd /c "$finsql command=buildobjectsearchindex, servername=$($ServerInstance.DatabaseServer)\$($ServerInstance.DatabaseInstance), database=$($ServerInstance.DatabaseName), logfile=out.txt"
if (Test-Path "Out.txt") {
    write-error (get-content out.txt)
}

Set-NAVServerInstance -ServerInstance NAV -Restart

