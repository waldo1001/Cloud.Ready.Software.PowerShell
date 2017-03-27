function Start-NAVVersionModuleSearch {

    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .EXAMPLE
        
    #>

    $Scripts = @()
    $Scripts += Get-SearchNAVModuleJobTask 'Microsoft.Dynamics.Nav.Management.psm1' 'Microsoft.Dynamics.Nav.Management.dll' 'NAV Management'
    $Scripts += Get-SearchNAVModuleJobTask 'Microsoft.Dynamics.NAV.Model.Tools.psd1' 'Microsoft.Dynamics.NAV.Model.Tools.dll' 'NAV Model Tools'
    $Scripts += Get-SearchNAVModuleJobTask 'Microsoft.Dynamics.Nav.Apps.Tools.psd1' 'Microsoft.Dynamics.Nav.Apps.Tools.dll' 'NAV Apps Tools'

    if ($global:NAVJobManager -eq $null) {
        $global:NAVJobManager = New-Object PSObject        
    }

    if ($global:NAVJobManager.MVS -eq $null) {
        # MVS => Module-Version Search
        $mvs = New-Object PSObject
        $mvs | Add-Member NoteProperty ScriptsToRun @()
        $mvs | Add-Member NoteProperty Jobs @()
        $mvs | Add-Member NoteProperty Results @()
        $mvs | Add-Member NoteProperty Errors @()
        
        $global:NAVJobManager | Add-Member MVS $mvs
    }

    $global:NAVJobManager.MVS.ScriptsToRun = $Scripts

    $counter = 0;
    foreach ($script in $global:NAVJobManager.MVS.ScriptsToRun) {
            
        try {
            $global:NAVJobManager.MVS.Jobs += Start-Job -ScriptBlock $script.ScriptBlock -ArgumentList $script.NavModuleName, $script.NavModuleDllName, $script.NavModuleTitle
            
            Register-ObjectEvent -InputObject $global:NAVJobManager.MVS.Jobs[$counter] -EventName StateChanged -Action  { 

                try {
                    if($sender.State -ne [System.Management.Automation.JobState]::Completed) {
                        throw "Task has not completed correctly."
                    }

                    $global:NAVJobManager.MVS.Results += Receive-Job $Sender -Keep
                    $global:NAVJobManager.MVS.Jobs = $global:NAVJobManager.MVS.Jobs | Where-Object { $_.Id -ne $sender.Id }

                    Unregister-Event $eventsubscriber.SourceIdentifier                    
                    Remove-Job $Sender
                }
                catch {
                    $global:NAVJobManager.MVS.Errors += $_.Exception
                }

            } | Out-Null

            $counter++
        }
        catch {
            $global:NAVJobManager.MVS.Errors += $_.Exception
        }
    }

    #return $global:JobManager
}