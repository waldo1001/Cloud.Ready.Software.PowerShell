function Export-NAVEventPublishers {
    param (
        [parameter(Mandatory = $true)]    
        [String] $ModuleToolAPIPath,
        [parameter(Mandatory = $true)]
        [String] $SourceFile,
        [parameter(Mandatory = $true)]
        [String] $DestinationFolder
    )
    
    import-module (join-path $ModuleToolAPIPath NavModelToolsAPI.dll) -WarningAction SilentlyContinue -ErrorAction Stop
    
    $Model = Get-NAVObjectModel -NavObjectsTextFile $SourceFile -TimeExecution     
    #write-verbose -Message "Number of publishers: $($Model.EventPublishers.Count)" 
    $Publishers = $Model.EventPublishers
    
    $Problems = @()
    $NoProblems = @()
    $Content = @()
    
    $NumberOfRaises = $publishers.usedby | where MappingType -eq CodeLines | Group UsingElement | Select Count, Name
    $Content += "$(($Publishers | measure).Count) published events found."
    $Content += "Number of times a publisher was raised: "
    foreach ($NumberOfRaise in $NumberOfRaises) {
        $Content += "$($NumberOfRaise.Count) : $($NumberOfRaise.Name)"    
    }
    
    
    $Content2 = @()
    $Content2 += ''
    $Content2 += 'DETAILS:'
    
    Foreach ($Publisher in $Publishers) {
        $Content2 += $Publisher.FullName
    
        $UsedBys = $publisher.UsedBy | where MappingType -eq CodeLines
    
        if ($UsedBys.Count -eq 0) {
            $usedbys = Find-CodeLines -ObjectModel $Model -SearchString $Publisher.Name -HideProgress 
        }
    
        if ($UsedBys.Count -eq 0) {
            Write-host -ForegroundColor Red "Nothing Found for $($Publisher.FullName)"
            $Problems += $Publisher
            $Content += "0 : $($Publisher.FullName)"
        }
        else {
            $NoProblems += $Publisher
        }
    
               
        
        foreach ($UsedBy in $UsedBys) {
            $Content2 += "  Raised in: " + $UsedBy.SourceElement.FullName
    
            if (!$UsedBy.SourceElement.CodeLines) {
                $Source = $UsedBy.CodeLines
            }
            else {
                $Source = $UsedBy.SourceElement.CodeLines
            } 
            $Content2 += "    Code lines:"
            $Content2 += Get-NAVCodeSnippet -CodeLines $Source  -FocusText $Publisher.Name -NumberOfContextLines 10 -Indent 4
        }
        
    }
    
    $Content += $Content2
    
    $ExportFilename = "$DestinationFolder\Publishers_$([io.path]::GetFileNameWithoutExtension($SourceFile)).txt"
    $Content | Set-Content -Path $ExportFilename     
}

