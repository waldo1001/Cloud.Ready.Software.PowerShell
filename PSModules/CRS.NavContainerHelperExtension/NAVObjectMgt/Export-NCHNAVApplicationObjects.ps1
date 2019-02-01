function Export-NCHNAVApplicationObjects {
    <#
    .SYNOPSIS
    Exports objects from an NAV (Business Central) database, on a Docker image.  The name of the file will be the 

    .PARAMETER ContainerName
    The containername from where it should export the objects

    .PARAMETER Filter
    The object filter
    
    #>

    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [String] $filter = ''
    )

    $destinationFolder = "C:\ProgramData\NavContainerHelper\Extensions\$ContainerName\"   

    $NavVersion = Get-NavContainerNavVersion -containerOrImageName $containerName 
    $tempFolder = Join-Path $destinationFolder $NavVersion
    $tempFile = Join-Path $tempFolder "objects.txt"
    $resultFile = Join-Path $destinationFolder "$NavVersion.txt"

    Remove-Item -Path $resultFile -Force -ErrorAction SilentlyContinue

    Export-NavContainerObjects -containerName $containerName -objectsFolder $tempFolder -exportTo 'txt file' -filter $filter | Out-Null
    Move-Item -Path $tempFile -Destination $resultFile | Out-Null
    Remove-Item -Path $tempFolder -Recurse -Force | Out-Null

    return (get-item $resultFile)
}