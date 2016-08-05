function Merge-NAVDateTime
{
    param (
        [String]$OriginalDate,
        [String]$OriginalTime,
        [String]$ModifiedDate,
        [String]$ModifiedTime,
        [String]$TargetDate,
        [String]$TargetTime,
        [Switch]$SwitchOriginalDate,
        [Switch]$SwitchModifiedDate,
        [Switch]$SwitchTargetDate
    )
    
    $OriginalTime = Fix-NAVTime $OriginalTime
    $ModifiedTime = Fix-NAVTime $ModifiedTime 
    $TargetTime = Fix-NAVTime $TargetTime
           
    Write-Verbose "Merging Dates: $OriginalDate, $ModifiedDate, $TargetDate"
    Write-Verbose "Merging Times: $OriginalTime, $ModifiedTime, $TargetTime"
    
    if ($SwitchOriginalDate) {
        $OriginalDate = Switch-NAVDate -DateString $OriginalDate
        Write-Verbose "OriginalDate switched to $OriginalDate"
    }
    if ($SwitchModifiedDate) {
        $ModifiedDate = Switch-NAVDate -DateString $ModifiedDate
        Write-Verbose "ModifiedDate switched to $ModifiedDate"
    }
    if ($SwitchTargetDate) {
        $TargetDate = Switch-NAVDate -DateString $TargetDate
        Write-Verbose "TargetDate switched to $TargetDate"
    }



    if ($OriginalDate) {
        
        try{
            $_Date = Get-Date ($OriginalDate)
        } catch {
            write-error "Error on Original Date: $OriginalDate .  You should probably use 'Switch-NAVDate' to fix the data format for the Original objects."
        }
        $OriginalDateTime = $_Date + $OriginalTime
    }
    try{
        $_Date = Get-Date ($ModifiedDate)
    } catch {
        write-error "Error on Modified Date: $ModifiedDate .  You should probably use 'Switch-NAVDate' to fix the data format for the Modified objects."
    }
    $ModifiedDateTime = $_Date + $ModifiedTime
    
    try{
        $_Date = Get-Date ($TargetDate)
    } catch {
        write-error "Error on Target Date: $TargetDate .  You should probably use 'Switch-NAVDate' to fix the data format for the Target objects."
    }

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