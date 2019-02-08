function Export-NCHNAVApplicationObjectsAsAL {
    <#
    .SYNOPSIS
    Exports objects from an NAV (Business Central) database, on a Docker image.  The name of the file will be the 

    .PARAMETER ContainerName
    The containername from where it should export the objects

    .PARAMETER Filter
    The object filter

    .PARAMETER extensionStartId
    default = 70000000
    the startId for extension objects - actually not used.
    
    #>

    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $false)]
        [String] $filter = '',
        [Parameter(Mandatory = $false)]
        [int]$extensionStartId = 70000000,
        [Parameter(Mandatory = $false)]
        [String] $DestinationPath,
        [Parameter(Mandatory = $false)]
        [Switch] $DoNotResetDestinationPath
    )

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # $targetfolder = Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -containerName $ContainerName -scriptblock {
        param(
            $ContainerName, $filter, $extensionStartId
        )

        $workingfolder = "C:\ProgramData\navcontainerhelper\Extensions\$ContainerName\Export-NAVALfromNAVApplicationObject"
        $targetfolder = "$workingfolder\AL"

        Remove-Item $workingfolder -Recurse -ErrorAction SilentlyContinue | Out-Null

        Export-NAVALfromNAVApplicationObject `
            -ServerInstance NAV `
            -WorkingFolder $workingfolder `
            -TargetPath $targetfolder `
            -Filter $filter `
            -extensionStartId $extensionStartId `
            -WarningAction SilentlyContinue | Out-Null
        
        return $targetfolder
    } -ArgumentList $ContainerName, $filter, $extensionStartId
    
    if ($DestinationPath) {
        if (!($DoNotResetDestinationPath)) {
            Remove-Item $DestinationPath -Force -Recurse -ErrorAction SilentlyContinue
        }
        if (!(Test-Path $DestinationPath)) {
            New-Item $DestinationPath -ItemType Directory
        }
        Get-ChildItem "C:\ProgramData\navcontainerhelper\Extensions\$containerName\Export-NAVALfromNAVApplicationObject\AL" | 
            Move-Item -Destination $DestinationPath -Force 
    }

    return $targetfolder
}