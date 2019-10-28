$ContainerName = 'bccurrent'

$UID = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force

New-NCHNAVSuperUser -ContainerName $ContainerName -Username $UID -Password $Password -CreateWebServicesKey