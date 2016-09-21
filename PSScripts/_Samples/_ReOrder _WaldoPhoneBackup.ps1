$FolderToReorder = '\\waldonas2\photo\_WaldoPhoneBackup'

$Items = Get-ChildItem $FolderToReorder -File
foreach ($Item in $Items){
    $ImgData = New-Object System.Drawing.Bitmap($Item.FullName)
    try
    {
        # Gets 'Date Taken' in bytes 
        [byte[]]$ImgBytes = $ImgData.GetPropertyItem(36867).Value 
    }
    catch
    {
        [string]$ErrorMessage = ( 
            (Get-Date).ToString('yyyyMMdd HH:mm:ss') + "`tERROR`tDid not change name for " + $Img.Name + ". Reason: " + $Error 
            ) 
        $Script:ErrorLogMsg += $ErrorMessage + "`r`n" 
        Write-Host -ForegroundColor Red -Object $ErrorMessage 
 
        # Clears any error messages 
        $Error.Clear() 
 
        # No reason to continue. Move on to the next file 
        continue 
    }

    [string]$dateString = [System.Text.Encoding]::ASCII.GetString($ImgBytes)

    [string]$dateTaken = [datetime]::ParseExact($dateString,"yyyy:MM:dd HH:mm:ss`0",$Null).ToString('yyyyMMdd_HHmmss') 

    $year = [datetime]::ParseExact($dateString,"yyyy:MM:dd HH:mm:ss`0",$Null).ToString('yyyy') 

    $DestinationPath = join-path $FolderToReorder $year
    if (!(test-path $DestinationPath)){New-Item $DestinationPath -ItemType directory}

    $DestinationFile = join-path $DestinationPath "$($dateTaken)$($Item.Extension)"

    $ImgData.Dispose()
    write-host "$($Item.FullName) --> $DestinationFile"
    #Move-Item -Path $Item.FullName -Destination $DestinationFile -Force
    $Item.MoveTo($DestinationFile)


}
