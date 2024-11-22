function Create-BCContainer{
    param(
        $containerName,
        $artifactUrl,
        $ContainerCredential,
        $myscripts,
        $publicdnsname
    )

    #$AdditionalParameters = @()
    #$AdditionalParameters += '-l "traefik.vsix.frontend.rule=PathPrefix:/' + $containerName + 'vsix;ReplacePathRegex: ^/' + $containerName + 'vsix(.*) /BC$1"'
    #$AdditionalParameters += '-l "traefik.vsix.port=8080"'

    New-BcContainer `
        -accept_eula `
        -accept_outdated `
        -containerName $containerName `
        -imageName $BaseName `
        -artifactUrl $artifactUrl `
        -license $LicenseFile `
        -Credential $ContainerCredential `
        -auth NavUserPassword `
        -updateHosts `
        -dns '8.8.8.8' `
        -shortcuts None `
        -doNotCheckHealth `
        -myscripts $myscripts `
        -useSSL `
        -assignPremiumPlan `
        -useTraefik `
        -PublicDnsName $publicdnsname `
        -includePerformanceToolkit `        -enableTaskScheduler `        -multitenant:$false         #-additionalParameters $AdditionalParameters
        #-isolation  `
        

    UnInstall-BcContainerApp -containerName $containerName -name "Tests-TestLibraries" -ErrorAction SilentlyContinue
 }


 Write-Host "Create-Container.ps1 loaded!" -ForegroundColor Yellow