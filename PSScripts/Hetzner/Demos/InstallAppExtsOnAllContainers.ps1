﻿$UserName = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Containers = Get-BcContainers

Get-BcContainers | Where-Object {$_ -ne 'Sandbox10' } | % {

    write-host "Publishing apps to container $($_)" -ForegroundColor Yellow

    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `
    
    
    Publish-BcContainerApp `
        -containerName $_ `
        -install `



    Write-Host "Sleeping..." -foregroundcolor Yellow
    Start-Sleep -Seconds 100 # intervals to divide the time a bit more (see if it's faster in a whole)
}