# . .\ArtifactSasToken.ps1
$LicenseFolder = 'C:\BCContainerSetup\Licenses'

function AddContainerEntry {
    Param(
        [string]
        $containerName,

        [string]
        $country,

        [ValidateSet("All", "Closest", "Current", "First", "Latest", "NextMajor", "NextMinor", "SecondToLastMajor")]
        [string]
        $select = "Latest",
        
        [ValidateSet("OnPrem", "Sandbox")]
        [string]
        $type,

        [switch]
        $insider = $false,

        [string]
        $imageName,

        [string]
        $licenseFile,

        [string]
        $version
    )

    $container = New-Object -TypeName PSObject
    $container | Add-Member -MemberType NoteProperty -Name 'ContainerName' -Value $containerName
    $container | Add-Member -MemberType NoteProperty -Name 'Country' -Value $country
    $container | Add-Member -MemberType NoteProperty -Name 'Select' -Value $select
    $container | Add-Member -MemberType NoteProperty -Name 'Type' -Value $type
    $container | Add-Member -MemberType NoteProperty -Name 'Insider' -Value $insider.IsPresent
    $container | Add-Member -MemberType NoteProperty -Name 'ImageName' -Value $imageName
    $container | Add-Member -MemberType NoteProperty -Name 'LicenseFile' -Value (Join-Path $LicenseFolder $LicenseFile)
    if ($version) {
        $container | Add-Member -MemberType NoteProperty -Name 'Version' -Value $version
    }
    $containers.Add($container)
}

$containers = New-Object System.Collections.Generic.List[System.Object]

AddContainerEntry `
    -containerName 'server' `
    -country us  `
    -type Sandbox `
    -imageName 'server' `
    -LicenseFile 'Latest.flf'

$i = 0
$containers | % {
    $i++
    Write-Host "$i. $($_.ContainerName) $($_.Version)"
}

$select = [int](Read-Host -Prompt 'Enter your selection')

if ((!$select) -or ($select -eq 0) -or ($select -gt $containers.Count)) {
    exit
}

$count = [int](Read-Host -Prompt 'Enter number of containers')
if ((!$count) -or ($count -eq 0)) {
    exit
}

Write-Host 'Creating containers...'


$container = $containers.Item($select - 1)

#Credentials
$UserName = 'admin'
$Password = ConvertTo-SecureString 'Training4You!' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$myscripts = New-Object System.Collections.Generic.List[System.Object]
$myscripts.Add("C:\BCContainerSetup\AdditionalOutput.ps1")
$myscripts.Add("C:\BCContainerSetup\SetupCertificate.ps1")
$myscripts.Add("C:\BCContainerSetup\star_waldo_be.pfx")

if ($container.Insider) {
    if ($container.Version) {
        $artifactUrl = Get-BCArtifactUrl -country $container.Country -type $container.Type -select $container.Select -storageAccount bcinsider -sasToken $sasToken -version $container.Version
    } else {
        $artifactUrl = Get-BCArtifactUrl -country $container.Country -type $container.Type -select $container.Select -storageAccount bcinsider -sasToken $sasToken
    }
} elseif ($container.Select -eq "NextMinor" -or $container.Select -eq "NextMajor") {
    $artifactUrl = Get-BCArtifactUrl -country $container.Country -type $container.Type -select $container.Select -sasToken $sasToken
}
elseif ($container.Version) {
    $artifactUrl = Get-BCArtifactUrl -country $container.Country -type $container.Type -version $container.Version
}
else {
    $artifactUrl = Get-BCArtifactUrl -country $container.Country -type $container.Type -select $container.Select 
}

$bcContainerHelperConfig.sandboxContainersAreMultitenantByDefault = $false


For ($i=1; $i -le $count; $i++) {
    $publicdnsname = "$($container.ContainerName)$($i).waldo.be"
    $publicdnsname

    $containerName = "$($Container.ContainerName)$($i)"

    $AdditionalParameters = @("--hostname $publicdnsname",
                              "-l `"traefik.enable=true`"",
                              "-l `"traefik.http.routers.$($containerName)-webclient.rule=Host(``$($publicdnsname)``)`"",
                              "-l `"traefik.http.routers.$($containerName)-webclient.entrypoints=websecure`"",
                              "-l `"traefik.http.routers.$($containerName)-webclient.tls=true`"",
                              "-l `"traefik.http.routers.$($containerName)-webclient.service=$($containerName)-webclient-service`"",
                              "-l `"traefik.http.services.$($containerName)-webclient-service.loadbalancer.server.scheme=https`"",
                              "-l `"traefik.http.services.$($containerName)-webclient-service.loadbalancer.server.port=443`"",
                              "-l `"traefik.http.routers.$($containerName)-soap.rule=Host(``$($publicdnsname)``)`"",
                              "-l `"traefik.http.routers.$($containerName)-soap.entrypoints=bc-soap`"",
                              "-l `"traefik.http.routers.$($containerName)-soap.tls=true`"",
                              "-l `"traefik.http.routers.$($containerName)-soap.service=$($containerName)-soap-service`"",
                              "-l `"traefik.http.services.$($containerName)-soap-service.loadbalancer.server.scheme=https`"",
                              "-l `"traefik.http.services.$($containerName)-soap-service.loadbalancer.server.port=7047`"",
                              "-l `"traefik.http.routers.$($containerName)-odata.rule=Host(``$($publicdnsname)``)`"",
                              "-l `"traefik.http.routers.$($containerName)-odata.entrypoints=bc-odata`"",
                              "-l `"traefik.http.routers.$($containerName)-odata.tls=true`"",
                              "-l `"traefik.http.routers.$($containerName)-odata.service=$($containerName)-odata-service`"",
                              "-l `"traefik.http.services.$($containerName)-odata-service.loadbalancer.server.scheme=https`"",
                              "-l `"traefik.http.services.$($containerName)-odata-service.loadbalancer.server.port=7048`"",
                              "-l `"traefik.http.routers.$($containerName)-dev.rule=Host(``$($publicdnsname)``)`"",
                              "-l `"traefik.http.routers.$($containerName)-dev.entrypoints=bc-dev`"",
                              "-l `"traefik.http.routers.$($containerName)-dev.tls=true`"",
                              "-l `"traefik.http.routers.$($containerName)-dev.service=$($containerName)-dev-service`"",
                              "-l `"traefik.http.services.$($containerName)-dev-service.loadbalancer.server.scheme=https`"",
                              "-l `"traefik.http.services.$($containerName)-dev-service.loadbalancer.server.port=7049`"")

    Remove-BcContainer $containerName
    Measure-Command {
        New-BcContainer `
            -accept_eula `
            -accept_outdated `
            -containerName $containerName `
            -imageName $container.ImageName `
            -artifactUrl $artifactUrl `
            -license $container.LicenseFile `
            -Credential $ContainerCredential `
            -auth NavUserPassword `
            -updateHosts `
            -dns '8.8.8.8' `
            -isolation hyperv `
            -shortcuts None `
            -doNotCheckHealth `
            -myscripts $myscripts.ToArray() `
            -useSSL `
            -assignPremiumPlan `
            -useTraefik `
            -PublicDnsName $publicdnsname
            #-additionalParameters $AdditionalParameters `
    }

}

