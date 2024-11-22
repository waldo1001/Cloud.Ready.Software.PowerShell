$AppFolder = "C:\Users\Administrator\Desktop\Scripts\BCTechDaysDemo\apps"
$AppFiles = Get-childItem $AppFolder

$ContainerName = 'BCTechDays'

foreach ($AppFile in $AppFiles)
{
    Publish-BcContainerApp -containerName $ContainerName -appFile $AppFile.FullName -skipVerification -syncMode ForceSync
    
}