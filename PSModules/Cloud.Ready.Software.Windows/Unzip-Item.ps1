function Unzip-Item
{
    [CmdletBinding()]
    Param
    (
        # The full source-filepath of the file that should be unzipped
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Fullname')] 
        $SourcePath,

        # The full Destionation-path where it should be unzipped
        [String]
        $DestinationPath
    )
    process
    {
        if (-not (Test-Path $DestinationPath)){New-Item -Path $DestinationPath -ItemType directory}
        Unblock-File $DestinationPath 
        $helper = New-Object -ComObject Shell.Application
        $files = $helper.NameSpace($SourcePath).Items()
        $helper.NameSpace($DestinationPath).CopyHere($files) | Out-Null

    }
   }
