. '.\_Settings.ps1'

$FolderToJoin = "C:\ProgramData\NavContainerHelper\Upgrades\DistriCU3_Result_Fixed\MergeResult"

Invoke-ScriptInNavContainer -containerName $ContainerName -ScriptBlock {
    param(
        $FolderToJoin
    )

    $FinalResult = "$FolderToJoin.txt"
    Join-NAVApplicationObjectFile -Source $FolderToJoin -Destination $FinalResult

    
} -ArgumentList $FolderToJoin
