function Switch-NAVDate{
    param(
        [String] $DateString
    )

    $DateArray = $DateString -split ''
    $NewDate = ($DateArray[4..5]+ '/' + $DateArray[1..2] + '/' +  $DateArray[7..8]) -join ''
    
    return $NewDate
}