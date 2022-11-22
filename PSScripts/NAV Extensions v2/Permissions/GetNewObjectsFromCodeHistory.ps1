$Sourcebranch = 'be-19'
$Targetbranch = 'be-20'
$ForcePull = $false
$ObjectType = 'Table'

set-location "C:\_source\MSDyn365BC.Code.History"

$ObjectPattern = '(ObjectType) +([0-9]+) +("[^"]*"|[\w]*)([^"\n]*"[^"\n]*)?'
if ($ObjectType){
    $ObjectPattern = $ObjectPattern -replace "ObjectType", $ObjectType
} else {
    $ObjectPattern = $ObjectPattern -replace "ObjectType", 'codeunit|page|pagecustomization|pageextension|reportextension|permissionset|permissionsetextension|profile|query|report|requestpage|table|tableextension|xmlport|enum|enumextension|controladdin|interface|interface|entitlement|controladdin'
}

if ($ForcePull){
    & git config diff.renameLimit 999999
    & git checkout $SourceBranch 
    & git prune
    & git pull 
    & git checkout $TargetBranch 
    & git prune
    & git pull 
    & git checkout master
    & git prune
}

$AllObjects = . git diff $SourceBranch $TargetBranch --diff-filter=A --name-only

if ($ObjectType){
    $SelectString = ".*(\.$ObjectType).al"
} else {
    $SelectString = ".*.al"
}

$AllObjects | Select-String $SelectString | ForEach-Object {
    $CurrObj = $_
    
    $MatchingLines = Get-Content $CurrObj | Select-String $ObjectPattern
    
    if($MatchingLines){
        $MatchingLines = $MatchingLines.ToString();

        $IsTemp = Get-Content $CurrObj | Select-String "TableType = Temporary"

        if ($IsTemp){
            $MatchingLines += " *** TEMP ***"
        }
        Write-Host $MatchingLines -ForegroundColor Green

    } else {
        Write-Host $CurrObj -ForegroundColor Yellow
    }
    
}
