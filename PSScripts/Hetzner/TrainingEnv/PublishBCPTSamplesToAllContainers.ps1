$UserName = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Containers = Get-BcContainers

Get-BcContainers | % {

    write-host "Publishing apps to container $($_)" -ForegroundColor Yellow

    Publish-BcContainerApp `
        -containerName $_ `        -appFile "C:\Users\Administrator\Desktop\Scripts\TrainingEnv\Apps\Microsoft_Performance Toolkit Samples.app" `        -skipVerification `
        -install `        -ignoreIfAppExists `        -syncMode ForceSync `        -sync `        -useDevEndpoint `        -credential $ContainerCredential `        -ErrorAction Continue


}