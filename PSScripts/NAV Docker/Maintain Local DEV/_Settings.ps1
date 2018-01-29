$DockerHost = 'waldocorevm'

$Licensefile = 'C:\ProgramData\NavContainerHelper\NAV2018License.flf'
$Memory = '3G'

#Credentials
$username = 'waldo'
$password = 'waldo1234'
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)

