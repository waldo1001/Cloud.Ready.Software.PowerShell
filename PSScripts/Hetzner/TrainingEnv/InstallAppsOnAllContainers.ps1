$UserName = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Containers = Get-BcContainers


Get-BcContainers | Where-Object {$_ -notin 'Sandbox9','Sandbox8','BCTechDays'} | % {

    write-host "Publishing apps to container $($_)" -ForegroundColor Yellow

    Write-host "Removing Performance killers" -foregroundcolor green
    UnInstall-BcContainerApp -containerName $_ -name "Tests-TestLibraries" -ErrorAction SilentlyContinue
    UnInstall-BcContainerApp -containerName $_ -name "Tests-Misc" -ErrorAction SilentlyContinue

    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfTool_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue 

    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue


    Write-Host "Sleeping..." -foregroundcolor Yellow
    Start-Sleep -Seconds 100 # intervals to divide the time a bit more (see if it's faster in a whole)
}