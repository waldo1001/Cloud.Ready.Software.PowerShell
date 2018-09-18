. '.\_Settings.ps1'
<#
Enter-PSSession $DockerHost -Credential (Get-Credential)
Enter-NavContainer -containerName $DockerContainerName
#>

$CurrentProduct = 'Distri'
$objectfile     = "C:\ProgramData\navcontainerhelper\Upgrades\Distri110\2BeReleased\Originals.txt"
$ProductVersion = 'I11.0'
$ModifiedOnly   = $true

switch ($CurrentProduct)
{
    'Food' {    
        $VersionPrefix  = 'NAVW1','NAVBE','I7','I8','IB','SI','IF' 
    }
    'Distri' {  
        $VersionPrefix  = 'NAVW1','NAVBE','Test','I' 
    }
    'Base' {
        $VersionPrefix  = 'NAVW1','NAVBE','Test','I7','I8','I9','IB' 
    }
    Default {
        write-error "Unknown product '$CurrentProduct'"
    }
}

$WorkingFolder = (Get-ChildItem $objectfile).Directory
$SplitFolder   = (Join-Path $WorkingFolder '\Split\') 

if (Test-Path $SplitFolder){
    remove-item -Path $SplitFolder -Recurse
} 
Write-host -ForegroundColor green "Splitting $objectfile to $SplitFolder"
Split-NAVApplicationObjectFile -Source $objectfile -Destination $SplitFolder -Force

$OriginalFile = (join-path $WorkingFolder 'Original.txt')
if (!(Test-Path $OriginalFile)){
    Write-host -ForegroundColor green "Creating original file $OriginalFile"
    join-navapplicationObjectFile -Source $SplitFolder -Destination $OriginalFile -Force
}


Write-host -ForegroundColor green "Reading objects to memory from $SplitFolder"
$Objects = Get-NAVApplicationObjectProperty -Source $SplitFolder 

$VersionlistCompare = @()
Write-host -ForegroundColor green "Start VersionList-Merge"
foreach ($object in $Objects) {
    $ObjectComparison = New-object System.Object
    $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'OldVersionList' -Value $object.VersionList
    $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'NewVersionList' -Value (Release-NAVVersionList -VersionList $object.VersionList -ProductVersion $ProductVersion -Versionprefix $VersionPrefix)
    $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'WasModified' -Value $Object.Modified
    
    
    if ((-not($ModifiedOnly)) -or ($ModifiedOnly -and ($object.Modified))){
        Set-NAVApplicationObjectProperty -TargetPath $object.FileName `
                        -ModifiedProperty No `
                        -DateTimeProperty (get-date -Hour 12 -Minute 0 -Second 0 -Format g) `
                        -VersionListProperty $ObjectComparison.NewVersionList                

        $VersionlistCompare += $ObjectComparison
    }
}

$ReleasedFile = (join-path $WorkingFolder 'Released.txt')
Write-host -ForegroundColor green "Writing released file $ReleasedFile"
Join-NAVApplicationObjectFile -Source (join-path $SplitFolder '\*.txt') -Destination $ReleasedFile -Force

Remove-Item $SplitFolder -Recurse -Force

$VersionlistCompare | Format-Table -AutoSize
