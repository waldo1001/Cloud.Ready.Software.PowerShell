$AppFolder = "C:\Users\ericw\Dropbox\GitHub\iFacto\KTN\Finance\W1"
$TestFolder = "C:\Users\ericw\Dropbox\GitHub\iFacto\KTN\Finance\W1\Test"
$TestAppFolder = "C:\Users\ericw\Dropbox\GitHub\iFacto\KTN\Finance\W1.Test"

function IsTestCodeunit {
    param(
        [System.IO.FileInfo] $alFile
    )

    #if (!(IsCodeunit -alFile)) {return $false}
    $alContent = $alFile | Get-Content 
    $IsCodeunit = $null -ne ($alContent | Select-String '(codeunit) +([0-9]+) +("[^"]*"|[\w]*)([^"\n]*"[^"\n]*)?' -AllMatches)
    $IsTestCodeunit = $null -ne ($alContent | Select-String 'Subtype ?= ?Test' -AllMatches)
    return ($IsCodeunit -and $IsTestCodeunit)

}

function AllTestCodeunitFiles {
    param(
        [String] $AppFolder
    )

    $TestCodeunits = @()

    foreach ($alFile in (Get-ChildItem $AppFolder -Recurse -Filter "*.al")) {
        if (IsTestCodeunit -alFile $alFile ){
            $TestCodeunits += $alFile
        }
    }

    return $TestCodeunits
}


$AllCUs = AllTestCodeunitFiles -AppFolder $AppFolder
$AllCUs.Count