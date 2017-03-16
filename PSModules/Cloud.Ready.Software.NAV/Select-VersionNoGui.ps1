function Select-VersionNoGui {

    <#
        .SYNOPSIS
        Show non-GUI dialog and let the user select NAV version.
        .DESCRIPTION
        Show non-GUI dialog and let a user select NAV version (if multiple versions present).
        .EXAMPLE
        Import-NavModulesGlobally
    #>

    [CmdletBinding()]
    param (
        
        [parameter(Mandatory=$true)]
        [hashtable]$versions=@{},
        
        [parameter(Mandatory=$true)]
        [string]$importType="Your NAV module"

    )

    switch ($versions.Count) {
        0 {
            Write-Error "$importType is probably missing or has been installed in an unusual folder!"
        } 
        1 {
            $retVal = $versions.GetEnumerator() | Select-Object -First 1
        } 
        # More than one version
        default {

            Write-Host "`n`tPlease select $importType version" -Fore Cyan

            [int]$menuChoice = 0
            while ( $menuChoice -lt 1 -or $menuChoice -gt $versions.Count ) {
                $i = 0
                Write-Host
                $versions.GetEnumerator() | ForEach-Object { 
                    $i += 1
                    Write-Host "`t`t[$i]`t$($_.Name)"
                }
                [Int]$menuChoice = Read-Host "`nPlease, select one of the options available"
            }
            $retVal = $versions.GetEnumerator() | Select-Object -Index ($menuChoice - 1)
        }
    }

    return $retVal
}