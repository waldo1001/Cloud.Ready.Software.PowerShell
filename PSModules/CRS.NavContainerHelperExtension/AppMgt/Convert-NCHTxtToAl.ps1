function Convert-NCHTxtToAl {
    <#
    .SYNOPSIS
    Converts txt to al.
        
    .PARAMETER ContainerName
    The Container
    
    .PARAMETER TxtFile
    Path to the txt-file that needs to be converted
    
    .PARAMETER sqlCredential
    SQL credential to be able to use the finsql
    
    .PARAMETER startId
    The startID for extension objects
    
    .PARAMETER objectsFilter
    The object filter that would identify all objects
    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        [Parameter(Mandatory = $true)]
        [String] $TxtFile,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential] $sqlCredential,
        [Parameter(Mandatory = $false)]
        [int] $startId = 50000,
        [Parameter(Mandatory = $false)]
        [String] $objectsFilter = ''
    )

    Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) on $env:COMPUTERNAME"

    $MainFolder = "C:\ProgramData\navcontainerhelper\ConvertTxt2Al"
    Write-host -ForegroundColor Green "Performing Txt2Al conversion on folder '$MainFolder'"

    $OriginalFolder = "$Mainfolder\Original"
    $ModifiedFolder = "$Mainfolder\Modified"
    $DeltaFolder = "$Mainfolder\Delta"
    $AlFolder = "$Mainfolder\Al"
    
    $OriginalObjectsStore = "C:\ProgramData\NavContainerHelper\Extensions\Original-$(Get-NavContainerNavVersion -containerOrImageName $ContainerName)-newsyntax"

    if (!(Test-path $OriginalObjectsStore)) {
        Export-NavContainerObjects `
            -containerName $ContainerName `
            -objectsFolder $OriginalObjectsStore `
            -sqlCredential $sqlCredential `
            -exportTo 'txt folder (new syntax)' `
            -filter ''
    }

    Import-ObjectsToNavContainer `
        -containerName $ContainerName `
        -ObjectsFile $TxtFile `
        -sqlCredential $sqlCredential

    Compile-ObjectsInNavContainer `
        -containerName $ContainerName `
        -filter 'Compiled=0' `
        -sqlCredential $sqlCredential `
        -ErrorAction Continue

    Remove-Item -Path $OriginalFolder -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $ModifiedFolder -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $DeltaFolder -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $AlFolder -Recurse -Force -ErrorAction SilentlyContinue
    
    Export-NavContainerObjects `
        -containerName $ContainerName `
        -objectsFolder $ModifiedFolder `
        -sqlCredential $sqlCredential `
        -exportTo 'txt file (new syntax)' `
        -filter $objectsFilter 
    
    Create-MyOriginalFolder `
        -originalFolder $OriginalObjectsStore `
        -modifiedFolder $ModifiedFolder `
        -myOriginalFolder $OriginalFolder

    Create-MyDeltaFolder `
        -containerName $ContainerName `
        -modifiedFolder $ModifiedFolder `
        -myOriginalFolder $OriginalFolder `
        -myDeltaFolder $DeltaFolder 
    
    Convert-Txt2Al `
        -containerName $ContainerName `
        -myDeltaFolder $DeltaFolder `
        -myAlFolder $AlFolder `
        -startId $startId

    Compress-Archive `
        -Path "$AlFolder\*.*" `
        -DestinationPath "$AlFolder.zip" `
        -Force

}