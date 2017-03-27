function New-NAVVersionJobManager {
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .EXAMPLE
        
    #>

    $cDef = 
@"
    using System.Collections.Generic;

    public class NAVVersionJobManager
    {
        //public List<NAVVersionModule> NAVVersionModuleList = new List<NAVVersionModule>();

        public void Add(string text)
        {
        }
    }
"@

    <#
    Add-Type -TypeDefinition $cDef
    $navVersionJobManager = New-Object NAVVersionJobManager
    
    return $navVersionJobManager
    #>

    $NAVModuleJobLoaderManager = new-object PSObject

    $NAVModuleJobLoaderManager | Add-Member NoteProperty Jobs -Value @{}
    $NAVModuleJobLoaderManager | Add-Member NoteProperty Results -Value @{}
    $NAVModuleJobLoaderManager | Add-Member NoteProperty JobEvents -Value @()
    $NAVModuleJobLoaderManager | Add-Member NoteProperty Errors -Value @()

    $NAVModuleJobLoaderManager | Add-Member ScriptMethod AddJob {
        param(
            <#
            [parameter(Mandatory=$true)]
            [System.Management.Automation.Job]$Job
            #>
            [ref]$Job
        )

        $jobName = $Job.Value.Name
        

        try {
            $null = Register-ObjectEvent $Job.Value -EventName StateChanged -SourceIdentifier AbrakaDabra01 -Action {
            #$jobEvent = Register-ObjectEvent $Job -EventName StateChanged -SourceIdentifier ($jobName + "End") -Action {

        
                try {
                    $job = ($sender -as [System.Management.Automation.Job])

                    if($job.State -eq [System.Management.Automation.JobState]::Completed)
                    {
                        $resultKey = $job.Name
                        $resultValue = Receive-Job $job.Name
                        $This.Results.Add($resultKey, $resultValue)                
                    }                
                }
                catch {                
                    Write-Host $_.Exception
                    $This.Errors += $_.Exception
                }
        
            }
            
            $This.Jobs.Add($jobName, $Job.Value)        
        }
        catch {
            Write-Host $_.Exception
            $This.Errors += $_.Exception
        }
        
    }

    return $NAVModuleJobLoaderManager
}