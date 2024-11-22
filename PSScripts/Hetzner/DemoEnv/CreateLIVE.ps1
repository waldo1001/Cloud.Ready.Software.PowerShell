$ContainerName = 'LIVE'
$artifactUrl = Get-BCArtifactUrl `
    -Type OnPrem `
    -Select Latest `
    -country be
$imageName = $ContainerName

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)


New-BcContainer `
    -accept_eula `
    -containerName $ContainerName  `
    -artifactUrl $artifactUrl `
    -imageName $imageName `
    -Credential $ContainerCredential `
    -auth "UserPassword" `
    -updateHosts `
    -alwaysPull `
    -includeTestToolkit `
    -includeTestLibrariesOnly `
    -licenseFile $containerLicenseFile

Invoke-ScriptInBcContainer -containerName $ContainerName -Verbose -scriptblock {    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
    install-packageprovider -name Nuget -force -minimumversion 2.8.5.201
    install-module ALOps.ExternalDeployer -Force -confirm:$false
    import-module ALOps.ExternalDeployer 
    Install-ALOpsExternalDeployer 
    New-ALOpsExternalDeployer -ServerInstance BC}