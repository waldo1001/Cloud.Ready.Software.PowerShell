. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$Containername = 'bconprem'
$ObjectFile = "C:\temp\13.0.24630.0-de.txt"
$Path = 'C:\Temp\'
$language = 'DEU'
$Encoding = 'OEM'

$ObjectFileOnContainer = Join-Path "C:\ProgramData\navcontainerhelper\Extensions\$Containername" (Get-Item $ObjectFile).Name
Copy-Item -Path $ObjectFile -Destination $ObjectFileOnContainer -Force

# $Containersession = Get-NavContainerSession -containerName $Containername
# Invoke-Command -Session $Containersession {
Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {

    param($Containername, $ObjectFileOnContainer, $language, $Encoding)

    Export-NAVApplicationObjectLanguage `
        -Source $ObjectFileOnContainer `
        -Destination (Join-Path "C:\ProgramData\navcontainerhelper\Extensions\$Containername" "$language.txt") `
        -Language $language `
        -Encoding $Encoding

} -ArgumentList $Containername, $ObjectFileOnContainer, $language, $Encoding

Copy-Item -Path (Join-Path "C:\ProgramData\navcontainerhelper\Extensions\$Containername" "$language.txt") -Destination (Join-Path $Path "$language.txt")

