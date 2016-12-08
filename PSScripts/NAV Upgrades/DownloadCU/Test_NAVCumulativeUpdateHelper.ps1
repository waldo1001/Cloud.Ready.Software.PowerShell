Load-NAVCumulativeUpdateHelper

$Locales = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadLocales(54317)
$MyDownload = $Locales | out-gridview -PassThru | foreach {
   $_.DownloadUrl
   Start-BitsTransfer -Source $_.DownloadUrl -Destination C:\_Download\Filename.zip
}


$MyDownload = [MicrosoftDownload.MicrosoftDownloadParser]::GetDownloadDetail(54317, 'en-US') | Select-Object *
$MyDownload


$resourceFiles = New-Object System.Collections.ArrayList(,$MyDownload) 

$resourceFiles = New-Object System.Collections.ArrayList($null)
$resourceFiles.AddRange($MyDownload) 