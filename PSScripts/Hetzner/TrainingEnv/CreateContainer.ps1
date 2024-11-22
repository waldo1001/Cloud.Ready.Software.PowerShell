$containerName = 'Sandbox1'
$LicenseFile = "https://www.dropbox.com/s/675hqssxew9pdkm/Latest.flf?dl=1"
$publicdnsname = 'Training.waldo.be'
$artifactUrl = Get-BCArtifactUrl -version 20.4.44313.45693

$UserName = 'admin'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$myscripts = New-Object System.Collections.Generic.List[System.Object]
$myscripts.Add("C:\BCContainerSetup\AdditionalOutput.ps1")
$myscripts.Add("C:\BCContainerSetup\SetupCertificate.ps1")
$myscripts.Add("C:\BCContainerSetup\star_waldo_be.pfx")

if ($psscriptroot) {
    . (join-path $psscriptroot "Create-Container.ps1")
}

Create-BCContainer `    -containerName $containerName `    -artifactUrl $artifactUrl `    -ContainerCredential $ContainerCredential `    -myscripts $myscripts.ToArray()  `    -publicdnsname $publicdnsname