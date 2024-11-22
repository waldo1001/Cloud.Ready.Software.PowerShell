$folder = 'C:\vsts-agent-win-x64-2.155.1\_work\r7\a'
set-location $folder

$containerName = 'QA'
$skipVerification = $true

UnPublish-BcContainerApp -containerName $containerName -appName "Default Test App Name" -unInstall -force -ErrorAction SilentlyContinue
UnPublish-BcContainerApp -containerName $containerName -appName "Default App Name" -unInstall -force -ErrorAction SilentlyContinue
UnPublish-BcContainerApp -containerName $containerName -appName "Default Base App Name" -unInstall -force -ErrorAction SilentlyContinue
        

$app = (Get-ChildItem -Recurse -Filter '*Default Base App Name*.app')[0].Fullname
Publish-BCContainerApp -containerName $containerName -appFile $app -skipVerification:$skipVerification -sync -syncMode Add 
Start-BcContainerAppDataUpgrade -containerName $containerName -appName "Default Base App Name"
$app = (Get-ChildItem -Recurse -Filter '*Default App Name*.app')[0].Fullname
Publish-BCContainerApp -containerName $containerName -appFile $app -skipVerification:$skipVerification -sync -syncMode Add 
Start-BcContainerAppDataUpgrade -containerName $containerName -appName "Default App Name"
$app = (Get-ChildItem -Recurse -Filter '*Default Test App Name*.app')[0].Fullname
Publish-BCContainerApp -containerName $containerName -appFile $app -skipVerification:$skipVerification -sync -syncMode Add
Start-BcContainerAppDataUpgrade -containerName $containerName -appName "Default Test App Name"
