function Unzip-NAVCumulativeUpdateDownload
{
    [CmdletBinding()]
    Param
    (
        # The full source-filepath of the file that should be unzipped
        [Parameter(Mandatory=$true)] 
        $SourcePath,

        # The full Destionation-path where it should be unzipped
        [String] $DestinationPath
    )
    Process
    {       
        #rename exe to zip to be able to unzip it
        Write-host "Unzipping CU to $DestinationPath" -ForegroundColor Green
        $SourcePathZip = [io.path]::ChangeExtension($SourcePath,'zip')
        Rename-Item $SourcePath $SourcePathZip | Out-Null
        
        Unzip-Item -SourcePath $SourcePathZip -DestinationPath $DestinationPath | Out-Null

        if ($SourcePath -ne $SourcePathZip) {
            Rename-Item $SourcePathZip $SourcePath | Out-Null
        }

        $ProductDVD = Get-ChildItem -Path $DestinationPath -Filter '*.zip'
        
        if ($ProductDVD){
            $SourcePath2 = $ProductDVD.FullName
            $DestinationPath2 = (join-path $ProductDVD.Directory ($ProductDVD.Name -replace '.zip',''))

            Unzip-Item -SourcePath $SourcePath2 -DestinationPath $DestinationPath2 | Out-Null
        } else
        {
            Write-Error 'Unknown file structure'
            break
        }

        Remove-Item -Path $SourcePath2 -Force | Out-Null

    }
    end
    {
        $DestinationPath2
    }
    
}