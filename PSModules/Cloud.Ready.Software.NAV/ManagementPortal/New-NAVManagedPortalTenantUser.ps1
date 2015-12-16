#Source: How Do I: Use Microsoft DYnamics NAV Management Portal Web Services with PowerShell
#https://mbspartner.microsoft.com/NAV/Videos/753

Function New-NAVManagedPortalTenantUser {
    param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]       
        [String] $Username,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String] $FullName,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String] $Email,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [PSCredential] $Credential,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String] $TenantId,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String] $GenericWebServiceURL        
    )

    Begin {
        Write-Host 'Connecting To WebServices...' -ForegroundColor green
        $WebServiceName = 'Page/ApplicationTenantUser'
        $TenantUserWebService = New-WebServiceProxy -uri ($GenericWebServiceURL -f $WebServiceName) -Credential $Credential
        Write-host "Connected To $($TenantUserWebService.Url)" -ForegroundColor green
    }
    
    Process{
        $newTenantUser = New-Object -TypeName "$($TenantUserWebService.getType().Namespace).ApplicationTenantUser"    
        $NewTenantUser.User_Name = $Username
        $NewTenantUser.Full_Name = $FullName
        $NewTenantUser.Contact_Email = $Email
        $NewTenantUser.Authentication_Email = $Email
        $NewTenantUser.Application_Tenant_ID = $TenantId

        $TenantUserWebService.Create([ref] $newTenantUser)

        $userPassword = $TenantUserWebService.New($newTenantUser.Key, $true)
        Write-Host ("Created Tenant User $FullName - Password: $UserPassword") -ForegroundColor Green

    }

    End{
        Write-host 'All users created' -ForegroundColor Green
    }
}