function Get-AlCodeCopInfo{
    param
    (
        [Alias("Path","Fullname")]
        [parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
        [string] $CodeAnalysisPath 
    )

    process{ 
        $CodeAnalysisFile = Get-Item $CodeAnalysisPath

        Write-Verbose "Handling $($CodeAnalysisFile.Name)"
        $assembly = [System.Reflection.Assembly]::LoadFrom($CodeAnalysisPath);

        $codeAssemblyRef = $assembly.GetReferencedAssemblies() | where { $_.Name -eq "Microsoft.Dynamics.Nav.CodeAnalysis"}
        if ($codeAssemblyRef -eq $null)
        {
            Write-Verbose "RefAssembly not found $($CodeAnalysisFile.Name)"
            return
        }
        
        #Load Referenced Assemblies
        Write-Verbose "Import Microsoft.CodeAnalysis.dll"
        Import-Module (Join-Path $CodeAnalysisFile.Directory "..\Microsoft.CodeAnalysis.dll") | Out-Null
        Write-Verbose "Import Microsoft.Dynamics.Nav.CodeAnalysis.dll"
        Import-Module (Join-Path $CodeAnalysisFile.Directory "..\Microsoft.Dynamics.Nav.CodeAnalysis.dll") | Out-Null

        #Get Descriptor
        $descriptor = $assembly.ExportedTypes | where { $_.FullName -ilike "*DiagnosticDescriptors*"}
        
        if ($descriptor -eq $null){
            Write-Verbose "Descriptor not found $($CodeAnalysisPath)" 
            return
        }

        $typeFields = $descriptor.GetFields()
    
        foreach ($typeField in $typeFields) {
            $fieldValue = $null
            $fieldValue = $typeField.GetValue($null)        
                        
            $fieldValue | Add-Member -Name "SourceAssembly" -MemberType NoteProperty -Value $assembly.FullName -Force:$true
            $fieldValue | Add-Member -Name "CopName" -MemberType NoteProperty -Force:$true -Value ([regex]::Matches($assembly.FullName, 'Microsoft\.Dynamics\.Nav\.(\w+)').Groups[1].Value)
             
            $fieldValue
        }
    }
    
}

