Function Add-NAVEnvironmentCurrentUser {

    param(
        [parameter(Mandatory=$true)]
        [String] $ServerInstance,
        [parameter(Mandatory=$false)]
        [String] $PermissionSetId='SUPER'
    )

    $CurrentUser = Get-WmiObject win32_useraccount -Filter "name = '$env:USERNAME' AND domain = '$env:USERDOMAIN'"
 
    $UserGuid = [guid]::NewGuid()
   
    
    if (-not (Get-NAVServerUser -ServerInstance $ServerInstance | where windowsSecurityID -eq $CurrentUser.SID)){
        New-NAVServerUser -ServerInstance $ServerInstance -WindowsAccount $CurrentUser.Name -FullName $CurrentUser.FullName 
    } else {
        Write-Warning "User $($CurrentUser.Name) already exists."
    }
    if (-not(Get-NAVServerUserPermissionSet -ServerInstance $ServerInstance -WindowsAccount $CurrentUser.Name -PermissionSetId $PermissionSetId)){
        New-NAVServerUserPermissionSet -ServerInstance $ServerInstance -PermissionSetId $PermissionSetId -WindowsAccount $CurrentUser.Name
    } else {
        Write-Warning "Permissionset $($PermissionSetId) already assigned to user $($CurrentUser.Name)."
    }

}