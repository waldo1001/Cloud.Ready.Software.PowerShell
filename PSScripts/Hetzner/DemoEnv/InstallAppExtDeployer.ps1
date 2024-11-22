$folder = 'C:\vsts-agent-win-x64-2.155.1\_work\r8\a'
set-location $folder

$containerName = 'QA'
$skipVerification = $true

$AppToDeploy =  (Get-ChildItem -Recurse -Filter '*Default Base App Name*.app')[0].Fullname

$APIBaseURL = "http://$($containerName):7048/BC/API/microsoft/automation/beta"

$pwd = ConvertTo-SecureString 'Waldo1234'-AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ('waldo', $pwd)

$Companies = Invoke-RestMethod -Method Get `
    -Uri "$APIBaseURL/companies" `
    -Credential $Credential

$companyId = $Companies.value[0].id

#GetExtensions
$getExtensions = Invoke-RestMethod -Method Get `
    -Uri "$APIBaseURL/companies($companyId)/extensions" `
    -Credential $Credential

$getExtensions.value.displayName

#Publish Extension
Invoke-RestMethod -Method Patch `
    -Uri "$APIBaseURL/companies($companyId)/extensionUpload(0)/content" `
    -Credential $credential `
    -ContentType "application/octet-stream" `
    -Headers @{"If-Match" = "*" } `
    -InFile $AppToDeploy | Out-Null

#Deployment progress
$extensionDeploymentStatusResponse = Invoke-RestMethod -Method Get `
    -Uri "$APIBaseURL/companies($companyId)/extensionDeploymentStatus" `
    -Credential $credential

$extensionDeploymentStatusResponse.value |  Where-Object { $_.publisher -eq $appJson.publisher -and $_.name -eq $appJson.name -and $_.appVersion -eq $appJson.version }
