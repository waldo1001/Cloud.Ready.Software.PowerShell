function Release-NCHNAVApplicationObjects {
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [Object] $ReleaseSettings
    )


    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        param(
            $ReleaseSettings
        )

        Write-Host "Releasing $($ReleaseSettings.ContainerPath)"

        $WorkingFolder = (Get-Item $ReleaseSettings.ContainerPath).Directory
        $SplitFolder = (Join-Path $WorkingFolder '\Split\') 
        
        if (Test-Path $SplitFolder) {
            $null = remove-item -Path $SplitFolder -Recurse
        } 
        Write-host "Splitting $($ReleaseSettings.ContainerPath) to $SplitFolder"
        $null = Split-NAVApplicationObjectFile -Source $ReleaseSettings.ContainerPath -Destination $SplitFolder -Force
        
        $OriginalFile = (join-path $WorkingFolder 'Original.txt')
        if (!(Test-Path $OriginalFile)) {
            Write-host "Creating original file $OriginalFile"
            $null = join-navapplicationObjectFile -Source $SplitFolder -Destination $OriginalFile -Force
        }
                
        Write-host "Reading objects to memory from $SplitFolder"
        $Objects = Get-NAVApplicationObjectProperty -Source $SplitFolder 
        
        $VersionlistCompare = @()
        Write-host "Start VersionList-Merge"
        foreach ($object in $Objects) {
            $ObjectComparison = New-object System.Object
            $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'OldVersionList' -Value $object.VersionList
            $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'NewVersionList' -Value (Release-NAVVersionList -VersionList $object.VersionList -ProductVersion $ReleaseSettings.ProductVersion -Versionprefix $ReleaseSettings.VersionPrefix)
            $ObjectComparison | Add-Member -MemberType NoteProperty -Name 'WasModified' -Value $Object.Modified
            
            
            if ((-not($ReleaseSettings.ModifiedOnly)) -or ($ReleaseSettings.ModifiedOnly -and ($object.Modified))) {
                Write-Host "$($object.FileName) - $($ObjectComparison.NewVersionList)"
                Set-NAVApplicationObjectProperty -TargetPath $object.FileName `
                    -ModifiedProperty No `
                    -DateTimeProperty (get-date -Hour 12 -Minute 0 -Second 0 -Format g) `
                    -VersionListProperty $ObjectComparison.NewVersionList                
        
                $VersionlistCompare += $ObjectComparison
            }
        }
        
        $ReleasedFile = (join-path $WorkingFolder 'Released.txt')
        Write-host "Writing released file $ReleasedFile"
        $null = Join-NAVApplicationObjectFile -Source (join-path $SplitFolder '\*.txt') -Destination $ReleasedFile -Force
        
        $null = Remove-Item $SplitFolder -Recurse -Force
        
        $ReleaseResult = @{}
        $ReleaseResult.VersionlistCompare = $VersionlistCompare 
        $ReleaseResult.ContainerFilePath = $ReleasedFile

        return $ReleaseResult
        
    } -ArgumentList $ReleaseSettings

}