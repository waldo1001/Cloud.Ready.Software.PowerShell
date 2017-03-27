function Get-SearchNAVModuleJobTask {
    <#
        .SYNOPSIS

        .DESCRIPTION

        .EXAMPLE

    #>

    [CmdletBinding()]
    param (      
        
        [parameter(Mandatory=$true)]
        [String]$navModuleName,
        
        [parameter(Mandatory=$true)]
        [String]$navModuleDllName,

        [parameter(Mandatory=$false)]
        [String]$navModuleTitle

    )

    if ([string]::IsNullOrEmpty($navModuleTitle)) {
        $navModuleTitle = $navModuleName
    }

    $task = New-Object PSObject

    $task | Add-Member NoteProperty NavModuleName -Value $navModuleName
    $task | Add-Member NoteProperty NavModuleDllName -Value $navModuleDllName
    $task | Add-Member NoteProperty NavModuleTitle -Value $navModuleTitle

    $task | Add-Member NoteProperty ScriptBlock -Value { param($navModuleName, $navModuleDllName, $navModuleTitle) Get-NAVModuleVersions $navModuleName $navModuleDllName $navModuleTitle } 

    return $task
}