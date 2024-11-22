$folder = 'C:\vsts-agent-win-x64-2.155.1\_work\r5\a'
set-location $folder


$containerName = 'QA'
$skipVerification = $true
$appFolders = (Get-ChildItem -Recurse -Filter '*.app').DirectoryName


$UserName = 'waldo'
$Password = ConvertTo-SecureString 'Waldo1234' -AsPlainText -Force
$ContainerCredential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)


$baseUrl = "http://$containerName/BC/API"

$companiesResponse = Invoke-WebRequest -Uri "$baseUrl/v1.0/companies" -Credential $credential
$companiesContent = $companiesResponse.Content
$companyId = (ConvertFrom-Json $companiesContent).value[0].id
break

Sort-AppFoldersByDependencies -appFolders $appFolders -WarningAction SilentlyContinue | ForEach-Object {
    Write-Host "Publishing $_"
    Get-ChildItem -Path $_ -Filter "*.app" | ForEach-Object {
        Invoke-WebRequest `
            -Method Patch `
            -Uri "$baseUrl/microsoft/automation/v1.0/companies($companyId)/extensionUpload(0)/content" `
            -Credential $credential `
            -ContentType "application/octet-stream" `
            -Headers @{"If-Match" = "*"} `
            -InFile $_ | Out-Null
    }
}