[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$TenantID = "123"
$ClientID = "456"
$ClientSecret = "789"

$authcontext = New-BcAuthContext `
      -clientID $clientId `
      -clientSecret $clientSecret `
      -tenantID $tenantId `
      -scopes 'https://api.partner.microsoft.com/.default'

$Products = Get-AppSourceProduct -authContext $authcontext
$Products.Count

get-command *AppSource*