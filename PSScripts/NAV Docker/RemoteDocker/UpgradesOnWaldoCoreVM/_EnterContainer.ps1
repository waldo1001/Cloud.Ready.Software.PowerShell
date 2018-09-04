#Execute Set-By-Step
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
. '.\_Settings.ps1'

Enter-PSSession -ComputerName $DockerHost -Credential $DockerHostCredentials
break
Enter-NavContainer -containerName 'Upgrade'
