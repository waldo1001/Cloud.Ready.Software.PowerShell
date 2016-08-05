Function Fix-NAVTime {
    param(
        [String] $TimeString
    )

    $Result = $TimeString

    if ($TimeString.Length -eq 11) {
        $Result = $TimeString[0..7] -join ''
    }

    return $Result
}