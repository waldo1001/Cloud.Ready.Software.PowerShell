function Create-NAVAppPackage
{
    [CmdLetBinding()]
    param([Parameter(Mandatory=$true)] [string] $AppName,
          [Parameter(Mandatory=$true)] [string] $BuildFolder,
          [Parameter(Mandatory=$true)] [string] $Publisher,
          [Parameter(Mandatory=$true)] [string] $Description,
          [string] $Version = '1.0.0.0',
          [string] $ApplicationID = '')

    if ($ApplicationID -eq '')
    {
        $ApplicationID = [guid]::NewGuid()
    }

    $navAppManifestFile = $BuildFolder + $AppName + '.xml'

    $MyNewManifest = New-NAVAppManifest -Name $AppName -Publisher $Publisher -Description $Description -Id $ApplicationID -Version $Version -ErrorAction Stop #-Capabilities 0,1,2 
    
    Write-Host -Foregroundcolor Green "Manifest created: $MyNewManifest"
     
    return $MyNewManifest
}