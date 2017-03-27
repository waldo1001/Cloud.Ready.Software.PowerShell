function Select-NAVVersion {

    <#
        .SYNOPSIS
        Show non-GUI dialog and let the user select NAV version.
        .DESCRIPTION
        Show non-GUI dialog and let a user select NAV version (if multiple versions present).
        .EXAMPLE
        
    #>

    [CmdletBinding()]
    param (
        
        [parameter(Mandatory=$true)]
        [PSObject]$versions=@()        
    )

    $retVal = $null
    $selectedVersion = $null

    if (($versions -eq $null) -or ($versions.Count -eq 0))
    {
            Write-Error "There is no version-module to be imported!"
            return
    }

    $xValues = $versions | Select-Object ModuleTitle | Sort-Object -Property ModuleTitle -Unique
    $yValues = $versions | Select-Object VersionNo | Sort-Object -Property VersionNo -Unique

    switch ($yValues.Count) {
        0 {
            Write-Error "NAV is probably missing or has been installed in an unusual folder!"
        } 
        1 {
            $selectedVersion = $yValues[0].VersionNo
        } 
        # More than one version
        default {

            $matrixElements = @()

            for ($y = 0; $y -lt $yValues.Count; $y++) {
                
                $matrixElement = New-Object PSObject
                $matrixElement | Add-Member NoteProperty Index ($y + 1)
                $matrixElement | Add-Member NoteProperty VersionNo $yValues[$y].VersionNo

                for ($x = 0; $x -lt $xValues.Count; $x++) {
                    
                    $versonModuleData = $versions | Where-Object -Property VersionNo -eq $yValues[$y].VersionNo | Where-Object -Property ModuleTitle -eq $xValues[$x].ModuleTitle
                    $matrixElement | Add-Member NoteProperty $xValues[$x].ModuleTitle ($versonModuleData -ne $null)

                }
                
                $matrixElements += $matrixElement
            }

            Write-Host "`nSelect NAV version you are going to use:`n" -ForegroundColor Cyan

            [int]$menuChoice = 0
            while ( $menuChoice -lt 1 -or $menuChoice -gt $matrixElements.Count ) {
                $matrixElements | Format-Table -AutoSize | Out-Host        
                [Int]$menuChoice = Read-Host "`nPlease, select one of the options available"
            }

            $selectedVersion = $matrixElements[$menuChoice - 1].VersionNo
        }
    }
    
    $retVal = $versions | Where-Object -Property VersionNo -eq $selectedVersion

    return $retVal
}