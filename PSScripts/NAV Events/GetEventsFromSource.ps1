$DistriText = [System.IO.File]::OpenText('C:\temp\NAV2016_BE_CU2.txt')

$ResultArray = @()
$CurrentObject = ''
$i = 0

for(;;) {
    $TextLine = $DistriText.ReadLine()
    
    if ($TextLine -eq $null) { break }


    $i++

    switch ($true)
    {
        {$Textline.Contains("OBJECT ")} {$CurrentObject = $TextLine.TrimStart()}
        {$Textline.Contains("  [Integration")} {$CurrentEventType = $TextLine.TrimStart()}
        {$Textline.Contains("  [Business")} {$CurrentEventType = $TextLine.TrimStart()}
        
        {$Textline.Contains(" PROCEDURE") -and !([String]::IsNullOrEmpty($CurrentEventType))} {
            $CurrentFunction = $TextLine.TrimStart()

            $MyObject = New-Object System.Object
            $MyObject | Add-Member -MemberType NoteProperty -Name Object -Value $CurrentObject
            $MyObject | Add-Member -MemberType NoteProperty -Name EventType -Value $CurrentEventType
            $MyObject | Add-Member -MemberType NoteProperty -Name Function -Value $CurrentFunction            
            $ResultArray += $MyObject

            $CurrentEventType = ''
        }             

        Default {}
    }

    Write-Progress -Activity "Reading through objects.." -Status $CurrentObject

}

$DistriText.Close()
$DistriText.Dispose()

$ResultArray | ogv