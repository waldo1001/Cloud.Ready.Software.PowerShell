$Name = 'ApplyTestDeltas'
$DeltaFiles = 'C:\Users\Administrator\Dropbox\GitHub\Waldo.NAV\WaldoNAVPad\AppFiles\*.DELTA'
$TargetServerInstance = 'DynamicsNAV90'
$WorkingFolder = join-path 'c:\_WorkingFolder' $Name

Set-Location 'C:\Users\Administrator\Dropbox\GitHub\Waldo.NAV\WaldoNAVPad\AppFiles'

Get-Item $DeltaFiles | select *
$NAVObjects = get-item $Deltafiles | Get-NAVApplicationObjectPropertyFromDelta
$NAVObjects | ft 


$NAVObjects = Get-NAVApplicationObjectPropertyFromDelta -Source '.\*.DELTA' 
$NAVObjects |ft

$DeltaFileFirstLine = (Get-Content .\PAG22.DELTA)[0]
$DeltaFileFirstLine


        
$regex = '(?<product>\w+?)\.(?<version>\d+?)\.'
$regex = '.+\((\w+) (\d+)\)'
$MatchedRegEx = [regex]::Match($DeltaFileFirstLine, $regex)
$MatchedRegEx.Groups.Item(0).value
$MatchedRegEx.Groups.Item(1).value
$MatchedRegEx.Groups.Item(2).value


$NAVObjects = get-item $Deltafiles | Get-NAVApplicationObjectProperty
foreach ($NAVObject in $NAVObjects){
    $MyNAVObject = New-Object PSObject

    $NAVObject | Get-Member -MemberType Properties | foreach {
        $MyNAVObject | Add-Member -MemberType NoteProperty -Name $_.Name -Value $NAVObject."$($_.name)"        
    }
    $MyNAVObject.ObjectType = 'waldo'
    $MyNAVObject
}


#reverse


$Mergeresult =     Update-NAVApplicationObject `        -TargetPath $ResultFolder `        -DeltaPath $ReverseFolder `        -ResultPath $WorkingFolder `
        -DateTimeProperty Now `        -ModifiedProperty Yes `        -VersionListProperty FromTarget `
        -ErrorAction Stop `        -Force


$Versionlist = "NAVW19.00.00.44974,NAVBE9.00.00.44974,ApplyTestDeltas,ApplyReverseDeltas"
$RemoveVersionList = 'ApplyReverseDeltas'
$NewVersionList = @()

$allVersions = @() + $Versionlist.Split(',')
$allVersions | foreach {
    if ($_ -ine $RemoveVersionList){
        $NewVersionList += $_
    }
}    
$NewVersionList -join ','