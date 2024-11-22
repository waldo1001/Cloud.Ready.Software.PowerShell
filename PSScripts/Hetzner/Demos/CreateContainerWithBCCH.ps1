$BaseName = 'BCTechDays'
$LicenseFile = "https://www.dropbox.com/scl/fi/uaakb760g9nb8xa8lw6p6/latest.bclicense?rlkey=gq440hloab4mtjwd2pagahr6g&dl=1"
$InsiderSASToken = "?sv=2021-06-08&ss=b&srt=sco&spr=https&st=2022-09-15T00%3A00%3A00Z&se=2023-04-01T00%3A00%3A00Z&sp=rl&sig=rBQiC8y0zbuWC66i2BJcVhydR3XD2aaz47aJ6q6zEss%3D"
$publicdnsname = 'demos.waldo.be'

#$artifactUrl = Get-BCArtifactUrl -select NextMajor -country us -sasToken $InsiderSASToken
$artifactUrl = Get-BCArtifactUrl -select Current -country us

$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)


$myscripts = New-Object System.Collections.Generic.List[System.Object]
$myscripts.Add("C:\BCContainerSetup\AdditionalOutput.ps1")
$myscripts.Add("C:\BCContainerSetup\SetupCertificate.ps1")
$myscripts.Add("C:\BCContainerSetup\star_waldo_be.pfx")

if ($psscriptroot) {
    . (join-path $psscriptroot "Create-Container.ps1")
}

$containerName = "$($BaseName)"

Create-BCContainer `    -containerName $containerName `    -artifactUrl $artifactUrl `    -ContainerCredential $ContainerCredential `    -myscripts $myscripts.ToArray()  `    -publicdnsname $publicdnsname
