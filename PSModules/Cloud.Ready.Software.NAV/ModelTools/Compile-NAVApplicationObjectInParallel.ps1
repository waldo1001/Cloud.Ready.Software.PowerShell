﻿<#
    Source: https://blogs.msdn.microsoft.com/nav/2014/11/27/how-to-compile-a-database-twice-as-fast-or-faster/
    Changed a little bit though..
#>

function Compile-NAVApplicationObjectInParallel{
    param (
     [Parameter(Mandatory=$true)]
     [String] $ServerInstance,
     [ValidateSet('Force','No','Yes')]
     [String] $SynchronizeSchemaChanges
    )
    $ServerInstanceObject = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance

    $DatabaseServer =  $ServerInstanceObject.DatabaseServer
    if (!([string]::IsNullOrEmpty($ServerInstanceObject.DatabaseInstance))){
        $DatabaseServer += "\$($ServerInstanceObject.DatabaseInstance)"
    }

     $objectTypes = 'Table','Page','Report','Codeunit','Query','XMLport','MenuSuite'
     $jobs = @()
     foreach($objectType in $objectTypes){
        $jobs += Compile-NAVApplicationObject $ServerInstanceObject.DatabaseName -DatabaseServer $DatabaseServer -Filter "Type=$objectType" -Recompile -SynchronizeSchemaChanges $SynchronizeSchemaChanges -AsJob
     }
 
     Receive-Job -Job $jobs -Wait
     Compile-NAVApplicationObject $DatabaseName -DatabaseServer $DatabaseServer -SynchronizeSchemaChanges $SynchronizeSchemaChanges
} 