function New-NAVSuperUser {
    param($username, $pwd, [Switch] $CreateWebServicesKey)

    New-NAVServerUser `
        -ServerInstance NAV `
        -UserName $username  `
        -Password (ConvertTo-SecureString $pwd -AsPlainText -Force) `
        -CreateWebServicesKey:$CreateWebServicesKey

    New-NAVServerUserPermissionSet `
        -Scope System `
        -ServerInstance NAV `
        -PermissionSetId SUPER `
        -UserName $username 


    Write-Host "UID: $username"
    write-Host "  pwd: $pwd"

    if ($CreateWebServicesKey) {
        write-Host "  WS-Key: $((Get-NAVServerUser -ServerInstance NAV | where username -like $username).WebServicesKey)"
    }
    
}
