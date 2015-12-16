#Source: How Do I: Use Microsoft DYnamics NAV Management Portal Web Services with PowerShell
#https://mbspartner.microsoft.com/NAV/Videos/753

Function New-NAVManagedPortalTenant {
    param(
        [PSCredential] $Credential,
        [String] $ApplicationServiceName,
        [String] $Tenant,
        [String] $Country,
        [String] $GenericWebServiceURL
    )
    $webservicename = 'Page/ApplicationTenant'
    $TenantWebService = New-WebServiceProxy -Uri ($GenericWebServiceURL -f $webservicename) -Credential $Credential
    Write-Host "Connected to $($TenantWebService.Url)" -ForegroundColor Green 

    $webservicename = 'Codeunit/Operation'
    $OperationWebService = New-WebServiceProxy -Uri ($GenericWebServiceURL -f $webservicename) -Credential $Credential
    Write-Host "Connected to $($OperationWebService.Url)" -ForegroundColor Green 

    #Create a new Tenant Instance
    $NewTenant = New-Object -TypeName "$($TenantWebService.GetType().Namespace).ApplicationTenant"
    $NewTenant.ApplicationServiceName = $ApplicationServiceName
    $NewTenant.Name = $Tenant
    $NewTenant.Country = $Country

    Write-Host "Creating tenant $Tenant" -ForegroundColor Green
    $TenantWebService.Create([Ref] $NewTenant)

    #Provisioning the tenant
    Write-Host "Begin Provisioning Tenant $Tenant" -ForegroundColor Green
    $token = $TenantWebService.BeginProvision($NewTenant.key)

    do{
        #Monitor status every 10 seconds
        Start-Sleep -s 10
        $OperationStatus = $OperationWebService.GetOperationStatus($token)
        Write-Host "Operation Status: $OperationStatus" -ForegroundColor Gray
    } while ($OperationStatus -eq 'Provisioning')

    #The tenant changed to Active, we need to GET the latest version of it through the web service
    $NewTenant = $TenantWebService.ReadByRecId($TenantWebService.GetRecIdFromKey($NewTenant.Key))

    Write-Host "Tenant Provisioned successfully with ID $($NewTenant.Id)" -ForegroundColor Yellow

    return $NewTenant.ID

}
