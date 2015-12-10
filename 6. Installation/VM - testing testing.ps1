$VMAdminUserName = 'Administrator'
$VMAdminPassword = ''

$credentialParam = @{}
if ($VMAdminUserName -and $VMAdminPassword) 
{
    $secureVMAdminPassword = ConvertTo-SecureString $VMAdminPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($VMAdminUserName, $secureVMAdminPassword)

    $credentialParam.Add("Credential", $credential)
} 

$session = New-PSSession  169.254.108.158 -Authentication Negotiate -Credential @credential
