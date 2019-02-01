function Merge-NCHNAVApplicationObjects {
    <#
    .SYNOPSIS
    Merge objects using a NAV Container on a remote Docker Host.
    
    .DESCRIPTION
    It is using the default merge commandlets coming from Microsoft, and the Cloud.Ready.Software.NAV module from waldo to merge objects.
    Things it considers/executes:
    - Merge the objects
    - Languages (avoid language conflicts by exporting and removing languages)
    - Merges version lists
    - Lists failed objects
    - Shows mergeresult
    - Saves mergeresult
       
    .PARAMETER ContainerName
    The Container used to merge
    
    .PARAMETER UpgradeSettings
    The is a dictionary - so a collection of settings.  See examples to see what settings there are, and how to create that dictionary.
    
    .EXAMPLE
    Creating the "UpgradeSettings" dictionary:
        #In one Dictionary, to be able to easily pass it to remote servers
        $UpgradeSettings = @{}

        #General
        $UpgradeSettings.UpgradeName = 'CustomerX'

        $UpgradeSettings.OriginalVersion = 'Distri81' 
        $UpgradeSettings.ModifiedVersion = 'CustomerX'
        $UpgradeSettings.TargetVersion = 'Distri110'

        $UpgradeSettings.LocalOriginalFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.OriginalVersion).zip"
        $UpgradeSettings.LocalModifiedFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.ModifiedVersion).zip"
        $UpgradeSettings.LocalTargetFile = "$env:USERPROFILE\Dropbox\Dynamics NAV\ObjectLibrary\$($UpgradeSettings.TargetVersion).zip"

        $UpgradeSettings.VersionListPrefixes = 'NAVW1', 'NAVBE', 'I'
        $UpgradeSettings.AvoidConflictsForLanguages = 'NLB','FRB','ENU','ESP'

        #Semi-fixed settings (scope within container)
        $UpgradeSettings.UpgradeFolder = 'C:\ProgramData\NavContainerHelper\Upgrades' #locally in the container
        $UpgradeSettings.ObjectLibrary = Join-Path $UpgradeSettings.UpgradeFolder '_ObjectLibrary'
        $UpgradeSettings.ResultFolder = Join-Path $UpgradeSettings.UpgradeFolder "$($UpgradeSettings.UpgradeName)_Result"

        $UpgradeSettings.OriginalObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.OriginalVersion).txt"
        $UpgradeSettings.ModifiedObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.ModifiedVersion).txt"
        $UpgradeSettings.TargetObjects = Join-Path -Path $UpgradeSettings.ObjectLibrary -ChildPath "$($UpgradeSettings.TargetVersion).txt"
    
    .EXAMPLE
    Perform upgrade:
        Merge-NCHNAVApplicationObjects `
            -ContainerName $ContainerName `
            -UpgradeSettings $UpgradeSettings

    .EXAMPLE
    A full example with collection of scripts for one upgrade can be found on my github: 
    https://github.com/waldo1001/Cloud.Ready.Software.PowerShell/tree/master/PSScripts/NAV%20Docker/RemoteDocker
    
    .NOTES
    This function is dependent from the Cloud.Ready.Software.* modules from waldo. Use the Install-NCHDependentModules to install the necessary modules on the remote servers/containers.
    
    #>

    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [Object] $UpgradeSettings
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    # $Session = Get-NavContainerSession -containerName $ContainerName
    # Invoke-Command -Session $Session -ScriptBlock {
    Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

        param(
            $UpgradeSettings
        )
        $StartedDateTime = Get-Date

        if (Test-Path $UpgradeSettings.ResultFolder) {
            Remove-Item -Path $UpgradeSettings.ResultFolder -Recurse -ErrorAction Stop -Confirm
        }

        Write-Host -ForegroundColor Green "Starting upgrade with following parameters:"
        write-host -ForegroundColor Gray -Object (ConvertTo-Json $UpgradeSettings)

        $MergeResult = Merge-NAVUpgradeObjects `
            -OriginalObjects $UpgradeSettings.OriginalObjects `
            -ModifiedObjects $UpgradeSettings.ModifiedObjects `
            -TargetObjects $UpgradeSettings.TargetObjects `
            -WorkingFolder $UpgradeSettings.ResultFolder `
            -CreateDeltas `
            -VersionListPrefixes $UpgradeSettings.VersionListPrefixes `
            -Force `
            -DoNotOpenMergeResultFolder `
            -AvoidConflictsForLanguages $UpgradeSettings.AvoidConflictsForLanguages
        
        $FilteredMergeResultFolder = Copy-NAVChangedMergedResultFiles -MergeResultObjects $MergeResult.MergeResult
        
        #Save Result
        $MergeResult | ConvertTo-Json | Set-Content -Path (Join-Path $UpgradeSettings.ResultFolder 'Mergeresult.json')
        $MergeResult | Export-Clixml -Path (Join-Path $UpgradeSettings.ResultFolder 'Mergeresult.xml')
        
        #Save Used Settings
        $UpgradeSettings | ConvertTo-Json | Set-Content -Path (Join-Path $UpgradeSettings.ResultFolder 'UpgradeSettings.json')

        #List Conflicts
        $NumberOfConflicts = ($MergeResult.Mergeresult | Where-Object {$_.MergeResult -eq 'Conflict'}).Count
        Write-host -foregroundcolor Magenta -Object "There are $NumberOfConflicts conflicts."                
        if ($NumberOfConflicts -ge 1) {
            $MergeresultSummary = $MergeResult.Mergeresult | Where-Object {$_.MergeResult -eq 'Conflict'} | Group-Object {$_.ObjectType} 
            foreach ($Item in $MergeresultSummary) {
                Write-Host "  $($Item.Count) $($Item.Name) Conflicts" -ForeGroundColor Gray
            }
        }

        #List Failed
        $NumberOfFails = ($MergeResult.Mergeresult | Where-Object {$_.MergeResult -eq 'Failed'}).Count
        Write-host -foregroundcolor Magenta -Object "There are $NumberOfFails failed objects"
        if ($NumberOfFails -ge 1) {
            Foreach ($item in ($MergeResult.Mergeresult | Where-Object {$_.MergeResult -eq 'Failed'})) {
                Write-Host "  $($Item.ObjectType) - $($Item.Id): $($Item.Error)" -ForeGroundColor Gray
            }
        }


        $StoppedDateTime = Get-Date
        Write-Host 'Total Duration' ([Math]::Round(($StoppedDateTime - $StartedDateTime).TotalSeconds)) 'seconds' -ForegroundColor Yellow

    } -ArgumentList $UpgradeSettings

}