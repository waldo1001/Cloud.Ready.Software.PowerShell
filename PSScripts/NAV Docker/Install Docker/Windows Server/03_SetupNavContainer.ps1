$hostName = "localhost"
$containerName = "DEM_Test"
$vmAdminUsername = "administrator"
$navAdminUsername = "admin"
$adminPassword = "admin1234"
$navDockerImage = "navdocker.azurecr.io/dynamics-nav:devpreview"
$registryUsername = "7cc3c660-fc3d-41c6-b7dd-dd260148fff7"
$registryPassword = "G/7gwmfohn5bacdf4ooPUjpDOwHIxXspLIFrUsGN+sU="
$clickonce = "Y"
$licenseFileUri = "https://www.dropbox.com/s/ikizvkpl0pgbwf1/2017%20DEV%20License%20CRS.flf?dl=1"
$certificatePfxUrl = "https://www.dropbox.com/s/t95z9lc4krhtdnv/Asterix.cloud-ready-software.com.pfx?dl=1"
$certificatePfxPassword = Get-Content (join-path (get-item $psISE.CurrentFile.FullPath).Directory 'Pwd_Certificate.txt' )
$publicDnsName = "Directions.cloud-ready-software.com"
$workshopFilesUrl = "" 
$style = "devpreview"


"G/7gwmfohn5bacdf4ooPUjpDOwHIxXspLIFrUsGN+sU=" | docker login "navdocker.azurecr.io" -u "7cc3c660-fc3d-41c6-b7dd-dd260148fff7" --password-stdin


if (!(Test-Path function:Log)) {
    function Log([string]$line, [string]$color = "Gray") {
        ("<font color=""$color"">" + [DateTime]::Now.ToString([System.Globalization.DateTimeFormatInfo]::CurrentInfo.ShortTimePattern.replace(":mm",":mm:ss")) + " $line</font>") | Add-Content -Path "c:\demo\status.txt"
        Write-Host -ForegroundColor $color $line 
    }
}

Import-Module -name navcontainerhelper -DisableNameChecking

#. (Join-Path $PSScriptRoot "settings.ps1")

$imageName = $navDockerImage.Split(',')[0]

docker ps --filter name=$containerName -a -q | % {
    Log "Removing container $containerName"
    docker rm $_ -f | Out-Null
}

$country = Get-NavContainerCountry -containerOrImageName $imageName
$navVersion = Get-NavContainerNavVersion -containerOrImageName $imageName
$locale = Get-LocaleFromCountry $country

Log "Using image $imageName"
Log "Country $country"
Log "Version $navVersion"
Log "Locale $locale"

# Override AdditionalSetup
# - Clear Modified flag on objects
'sqlcmd -d $DatabaseName -Q "update [dbo].[Object] SET [Modified] = 0"' | Set-Content -Path "c:\myfolder\AdditionalSetup.ps1"

if (Test-Path "C:\Program Files (x86)\Microsoft Dynamics NAV") {
    Remove-Item "C:\Program Files (x86)\Microsoft Dynamics NAV" -Force -Recurse -ErrorAction Ignore
}
New-Item "C:\Program Files (x86)\Microsoft Dynamics NAV" -ItemType Directory -ErrorAction Ignore | Out-Null



('Copy-Item -Path "C:\Program Files (x86)\Microsoft Dynamics NAV\*" -Destination "c:\navpfiles" -Recurse -Force -ErrorAction Ignore
$destFolder = (Get-Item "c:\navpfiles\*\RoleTailored Client").FullName
$ClientUserSettingsFileName = "$runPath\ClientUserSettings.config"
[xml]$ClientUserSettings = Get-Content $clientUserSettingsFileName
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""Server""]").value = "'+$containerName+'"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ServerInstance""]").value="NAV"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ServicesCertificateValidationEnabled""]").value="false"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ClientServicesPort""]").value="$publicWinClientPort"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ACSUri""]").value = ""
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""DnsIdentity""]").value = "$dnsIdentity"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ClientServicesCredentialType""]").value = "$Auth"
$clientUserSettings.Save("$destFolder\ClientUserSettings.config")
') | Add-Content -Path "c:\myfolder\AdditionalSetup.ps1"

IF ($certificatePfxUrl -ne "" -and $certificatePfxPassword -ne "") {

    Download-File -sourceUrl $certificatePfxUrl -destinationFile "c:\demo\certificate.pfx"
    ('$certificatePfxPassword = "'+$certificatePfxPassword+'"
    $certificatePfxFile = "c:\demo\certificate.pfx"
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePfxFile, $certificatePfxPassword)
    $certificateThumbprint = $cert.Thumbprint
    Write-Host "Certificate File Thumbprint $certificateThumbprint"
    if (!(Get-Item Cert:\LocalMachine\my\$certificateThumbprint -ErrorAction SilentlyContinue)) {
        Write-Host "Import Certificate to LocalMachine\my"
        Import-PfxCertificate -FilePath $certificatePfxFile -CertStoreLocation cert:\localMachine\my -Password (ConvertTo-SecureString -String $certificatePfxPassword -AsPlainText -Force) | Out-Null
    }
    $dnsidentity = $cert.GetNameInfo("SimpleName",$false)
    if ($dnsidentity.StartsWith("*")) {
        $dnsidentity = $dnsidentity.Substring($dnsidentity.IndexOf(".")+1)
    }
    Remove-Item $certificatePfxFile -force
    Remove-Item "c:\run\my\SetupCertificate.ps1" -force
    ') | Add-Content "c:\myfolder\SetupCertificate.ps1"

}
Log "Running $imageName"
if (Test-Path -Path 'c:\demo\license.flf' -PathType Leaf) {
    $containerId = docker run --env      accept_eula=Y `
                              --hostname $containerName `
                              --env      PublicDnsName=$publicdnsName `
                              --name     $containerName `
                              --publish  8080:8080 `
                              --publish  443:443 `
                              --publish  7046-7049:7046-7049 `
                              --env      publicFileSharePort=8080 `
                              --env      username="$navAdminUsername" `
                              --env      password="$adminPassword" `
                              --env      useSSL=Y `
                              --env      clickOnce=$clickonce `
                              --env      locale=$locale `
                              --env      licenseFile="c:\demo\license.flf" `
                              --volume   c:\demo:c:\demo `
                              --volume   c:\myfolder:c:\run\my `
                              --volume   "C:\Program Files (x86)\Microsoft Dynamics NAV:C:\navpfiles" `
                              --restart  always `
                              --detach `
                              $imageName
} else {
    $containerId = docker run --env      accept_eula=Y `
                              --hostname $containerName `
                              --env      PublicDnsName=$publicdnsName `
                              --name     $containerName `
                              --publish  8080:8080 `
                              --publish  443:443 `
                              --publish  7046-7049:7046-7049 `
                              --env      publicFileSharePort=8080 `
                              --env      username="$navAdminUsername" `
                              --env      password="$adminPassword" `
                              --env      useSSL=Y `
                              --env      clickOnce=$clickonce `
                              --env      locale=$locale `
                              --volume   c:\demo:c:\demo `
                              --volume   c:\myfolder:c:\run\my `
                              --volume   "C:\Program Files (x86)\Microsoft Dynamics NAV:C:\navpfiles" `
                              --restart  always `
                              --detach `
                              $imageName
}
if ($LastExitCode -ne 0) {
    throw "Docker run error"
}

Log "Waiting for container to become ready, this will only take a few minutes"
Start-Sleep -Seconds 60
$cnt = 150
do {
    $logs = docker logs $containerName
    Start-Sleep -Seconds 5
    $log = [string]::Join(" ",$logs)
} while ($cnt-- -gt 0 -and !($log.Contains("Ready for connections!")))

# Copy .vsix and Certificate to C:\Demo
Log "Copying .vsix and Certificate to C:\Demo"
Remove-Item "C:\Demo\$containerName" -recurse -Force -ErrorAction Ignore
New-Item "C:\Demo\$containerName" -ItemType Directory -Force -ErrorAction Ignore
docker exec -it $containerName powershell "copy-item -Path 'C:\Run\*.vsix' -Destination 'C:\Demo\$containerName' -force
copy-item -Path 'C:\Run\*.cer' -Destination 'C:\Demo\$containerName' -force
copy-item -Path 'C:\Program Files\Microsoft Dynamics NAV\*\Service\CustomSettings.config' -Destination 'C:\Demo\$containerName' -force
if (Test-Path 'c:\inetpub\wwwroot\http\NAV' -PathType Container) {
    [System.IO.File]::WriteAllText('C:\Demo\$containerName\clickonce.txt','http://${publicDnsName}:8080/NAV')
}"
[System.IO.File]::WriteAllText("C:\Demo\$containerName\Version.txt",$navVersion)
[System.IO.File]::WriteAllText("C:\Demo\$containerName\Country.txt", $country)
$certFile = Get-Item "C:\Demo\$containerName\*.cer"

# Install Certificate on host
if ($certFile) {
    $certFileName = $certFile.FullName
    Log "Importing $certFileName to trusted root"
    $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
    $pfx.import($certFileName)
    $store = new-object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::Root,"localmachine")
    $store.open("MaxAllowed") 
    $store.add($pfx) 
    $store.close()
}

Log -color Green "Container output"
docker logs $containerName | % { log $_ }

Log -color Green "Container setup complete!"
