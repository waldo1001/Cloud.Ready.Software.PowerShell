function Merge-NAVDateTime
{
    param (
        [String]$OriginalDate,
        [String]$OriginalTime,
        [String]$ModifiedDate,
        [String]$ModifiedTime,
        [String]$TargetDate,
        [String]$TargetTime
    )

    Write-Verbose "Merging Dates: $OriginalDate, $ModifiedDate, $TargetDate"
    Write-Verbose "Merging Times: $OriginalTime, $ModifiedTime, $TargetTime"
    if ($OriginalDate) {
        $_Date = Get-Date ($OriginalDate)
        $OriginalDateTime = $_Date + $OriginalTime
    }

    $_Date = Get-Date ($ModifiedDate)
    $ModifiedDateTime = $_Date + $ModifiedTime
    
    $_Date = Get-Date ($TargetDate)
    $TargetDateTime = $_Date + $TargetTime

    $FinalDateTime =  Get-Date ($TargetDateTime)
    if ($FinalDateTime -lt $ModifiedDateTime)
    {
        $FinalDateTime = $ModifiedDateTime
    }
    
    $Result = Get-Date $FinalDateTime -Format g
    Write-Verbose "Result: $Result"
    $Result
}