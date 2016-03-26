$Dictionary = @()
$test = @{'ENU'='Sales Order'}
$Dictionary += $Test
$test = @{'NLB'='Bestelling'}
$Dictionary += $Test
$test = @{'FRB'='Commande'}
$Dictionary += $Test
$test = @{'Sales Order-FRB'='Commande'}
$Dictionary += $Test

if([string]::IsNullOrEmpty($Dictionary.'Sales Order-NLB')){
    $test = @{'Sales Order-NLB'='Bestelling'}
    $Dictionary += $Test
}

$Dictionary