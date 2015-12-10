function Export-NAVCumulativeUpdateApplicationObjects {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $CUObjectFile,
        [Parameter(Mandatory=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$true)]
        [String] $Workingfolder
                
    )

    $CUObjects = $CUObjectFile | Get-NAVApplicationObjectProperty 
    $ServerInstanceObject = Get-NAVServerInstance4 -ServerInstance $ServerInstance

    $ExportPath = Join-Path $Workingfolder "Export_$($ServerInstance)\"
    $LogPath = Join-Path $ExportPath 'Log'
    $ResultFile = join-path $Workingfolder "$($ServerInstance).txt"

    if (test-path $ExportPath) {remove-item -Path $ExportPath -Recurse -Force}

    write-host "Eporting objects from $ServerInstance to $ResultFile" -ForegroundColor Green
    $i = 0
    ForEach ($CUObject in $CUObjects){
        $i++
        write-progress `
            -Activity "Exporting $($CUObject.ObjectType)_$($CUObject.Id).txt ..." `
            -PercentComplete (($i / $CUObjects.Count)*100)

        $null = 
            Export-NAVApplicationObject `
                -DatabaseName $ServerInstanceObject.DatabaseName `
                -Path (join-path $ExportPath "$($CUObject.ObjectType)_$($CUObject.Id).txt") `
                -DatabaseServer $ServerInstanceObject.DatabaseServer `
                -LogPath $LogPath `
                -Filter "type=$($CUObject.ObjectType);id=$($CUObject.Id)" `
                -ExportTxtSkipUnlicensed
    }

    $null = 
        Join-NAVApplicationObjectFile `
            -Source (join-path $ExportPath '*.txt') `
            -Destination $ResultFile `
            -Force

    $null = remove-item $ExportPath -Recurse -Force

    Get-Item $ResultFile
}