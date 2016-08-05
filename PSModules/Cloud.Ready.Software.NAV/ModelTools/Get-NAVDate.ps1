function Get-NAVDate {
    param(
        [String] $DateStringFromNAVObjectFile,
        [String] $Format
    )

    try   { Get-date $DateString -Format $Format}
    catch { Get-date (Switch-NAVDate -DateString $DateString) -Format $Format}


}
