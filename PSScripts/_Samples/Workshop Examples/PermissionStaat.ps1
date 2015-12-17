$AllUserPermissionSets = @()

$Tenants = Get-NAVServerInstance | Get-NAVTenant 
foreach($Tenant in $Tenants){
    $UserPermissionsets = $Tenant | Get-NAVServerUserPermissionSet
    

    foreach($UserPermissionset in $UserPermissionsets){

        $UserPermissionset | Add-Member -MemberType NoteProperty -Name ServerName -Value ([net.dns]::GetHostName())
        $UserPermissionset | Add-Member -MemberType NoteProperty -Name ServerInstance -Value $Tenant.ServerInstance
        $UserPermissionset | Add-Member -MemberType NoteProperty -Name Tenant -Value $Tenant.Id

        $AllUserPermissionSets += $UserPermissionset
    }
}

$AllUserPermissionSets | Select ServerName, ServerInstance, Tenant, UserName, PermissionSetID, CompanyName, Scope | ft



