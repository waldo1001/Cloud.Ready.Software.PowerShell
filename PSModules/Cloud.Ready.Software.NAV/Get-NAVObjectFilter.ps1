#included functions
function Get-NAVObjectFilter
{    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$ObjectType,
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [Object]$ObjectCollection

    )
    BEGIN
    {
    }
    PROCESS
    {
        $Filter = ''
        $ObjectCollection | Where-Object ObjectType -eq $ObjectType | foreach {$Filter = $Filter + "|" + $_.Id}
        $Filter = $Filter.Trim("|")
        Write-Host "$ObjectType : $Filter"
    }

}