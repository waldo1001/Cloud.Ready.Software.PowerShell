$BaseName = 'Sandbox'
$LicenseFile = "https://www.dropbox.com/s/awlc1cwml0ul1su/latest.bclicense?dl=1"
$InsiderSASToken = "?sv=2021-06-08&ss=b&srt=sco&spr=https&st=2022-09-15T00%3A00%3A00Z&se=2023-04-01T00%3A00%3A00Z&sp=rl&sig=rBQiC8y0zbuWC66i2BJcVhydR3XD2aaz47aJ6q6zEss%3D"
$publicdnsname = 'demos.waldo.be'
$count = [int](Read-Host -Prompt 'Enter number of containers')
if ((!$count) -or ($count -eq 0)) {
    exit
}
#$artifactUrl = Get-BCArtifactUrl -select NextMajor -country us -sasToken $InsiderSASToken
$artifactUrl = Get-BCArtifactUrl -select Current -country us

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

For ($i=1; $i -le $count; $i++) {
    $containerName = "$($BaseName)$($i)"

    Create-BCContainer `        -containerName $containerName `        -artifactUrl $artifactUrl `        -ContainerCredential $ContainerCredential `        -myscripts $myscripts.ToArray()  `        -publicdnsname $publicdnsname
}