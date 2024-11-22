$UserName = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Containers = Get-BcContainers

Get-BcContainers | Where-Object {$_ -like 'Sandbox*' } | Sort-Object | % {

    write-host "Publishing apps to container $($_)" -ForegroundColor Yellow

    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext1_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext2_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext3_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext4_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext5_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext6_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext7_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue
    
    
    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\waldo_BCPerfToolDemos_Ext8_1.0.0.0.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue



    Write-Host "Sleeping..." -foregroundcolor Yellow
    Start-Sleep -Seconds 100 # intervals to divide the time a bit more (see if it's faster in a whole)
}