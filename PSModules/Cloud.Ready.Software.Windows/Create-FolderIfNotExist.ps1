function Create-FolderIfNotExist
{
    [CmdletBinding()]
    param (
        [String]$MyFolder
          )

    if ( -Not (Test-Path $MyFolder)) 
    {
        New-Item $MyFolder -type directory
    }

}