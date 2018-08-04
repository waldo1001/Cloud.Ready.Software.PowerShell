#Enter DockerContainer

Enter-NavContainer -containerName  'devpreview'

$ConfigurationPackageFiles = Get-ChildItem C:\ConfigurationPackages

$ConfigurationPackageFiles | ForEach-Object {
    Import-NAVConfigurationPackageFile -Path $_.FullName -ServerInstance NAV 
    
}