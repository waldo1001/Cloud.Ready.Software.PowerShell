function Get-NAVDate {
    param(
        [String] $DateStringFromNAVObjectFile,
        [String] $Format
    )

    try   { Get-date $DateStringFromNAVObjectFile -Format $Format}
    catch { Get-date (Switch-NAVDate -DateString $DateString) -Format $Format}


}
