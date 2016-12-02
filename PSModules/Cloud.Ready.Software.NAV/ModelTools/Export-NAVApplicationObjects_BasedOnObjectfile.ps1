function Export-NAVApplicationObjects_BasedOnObjectfile {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [Object] $ObjectFile,
        [Parameter(Mandatory=$true)]
        [String] $ServerInstance,
        [Parameter(Mandatory=$true)]
        [String] $ResultFolder
                
    )
    Write-Verbose 'Starting Export-NAVApplicationObjects_BasedOnObjectfile'
    write-host "Eporting objects from $ServerInstance to $ResultFile based on $ObjectFile" -ForegroundColor Green

    $Objects = $ObjectFile | Get-NAVApplicationObjectProperty 
    $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

    $ExportPath = Join-Path $Workingfolder "Export_$($ServerInstance)\"
    $LogPath = Join-Path $ExportPath 'Log'
    $ResultFile = join-path $Workingfolder "$($ServerInstance).txt"

    if (test-path $ExportPath) {remove-item -Path $ExportPath -Recurse -Force}

    $i = 0
    ForEach ($Object in $Objects){
        $i++
        write-progress `
            -Activity "Exporting $($Object.ObjectType)_$($Object.Id).txt ... ($i/$($Objects.Count))" `
            -PercentComplete (($i / $Objects.Count)*100)

        Write-Verbose "Exporting $($Object.ObjectType)_$($Object.Id).txt ... ($i/$($Objects.Count))"

        $null = 
            Export-NAVApplicationObject2 `
                -ServerInstance $ServerInstance `                -Path (join-path $ExportPath "$($Object.ObjectType)_$($Object.Id).txt") `
                -LogPath $LogPath `
                -Filter "type=$($Object.ObjectType);id=$($Object.Id)"                 
    }

    $null = 
        Join-NAVApplicationObjectFile `
            -Source (join-path $ExportPath '*.txt') `
            -Destination $ResultFile `
            -Force

    $null = remove-item $ExportPath -Recurse -Force

    Get-Item $ResultFile
}