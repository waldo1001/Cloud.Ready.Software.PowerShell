$ConflictFiles = Get-ChildItem 'C:\Users\waldo\Dropbox\GitHub\iFacto.Products.Distri\Upgrade_Distri92_NAV2017CTP27\Conflicts'

$Conflicts = @()
foreach($ConflictFile in $ConflictFiles){
    Write-host $ConflictFile.BaseName
    $ObjectConflictHints = @()
    $ObjectConflictHints = (Get-Content $ConflictFile.FullName | Where-Object {$_ -like '*ConflictHint*'}).TrimStart()

    foreach ($ObjectConflictHint in $ObjectConflictHints){
        $Conflict = New-Object PSObject
        $Conflict | Add-Member -MemberType NoteProperty -Name 'Object' -Value $ConflictFile.BaseName
        $Conflict | Add-Member -MemberType NoteProperty -Name 'ConflictHint' -Value $ObjectConflictHint
        $Conflicts += $Conflict
    }
}