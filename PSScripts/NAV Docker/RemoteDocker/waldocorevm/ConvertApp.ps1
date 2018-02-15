# Convert a txt-file to al (txt2al.exe)

. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$TxtFile = 'C:\temp\CWF.txt'
$Containername = 'devpreview'
$startId = 70117820
$objectsFilter = 'Name=CWF*|ERR*'
$localResultFolder = 'C:\Temp\CWF_AL'

$UserName = 'sa'
$Password = ConvertTo-SecureString 'waldo1234' -AsPlainText -Force
$sqlCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)

$Result = 
    Convert-RDHTxtToAl `
        -DockerHost $DockerHost `
        -DockerHostCredentials $DockerHostCredentials `
        -DockerHostUseSSL:$DockerHostUseSSL `
        -DockerHostSessionOption $DockerHostSessionOption `
        -ContainerName $Containername `
        -TxtFile $TxtFile `
        -sqlCredential $sqlCredential `
        -startId $startId `
        -objectsFilter $objectsFilter `
        -LocalResultFolder $localResultFolder

Start (Get-Item $Result).Directory