function Publish-BCAppWithExternalDeployer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscredential] $Credential,
        [Parameter(Mandatory)]
        [string] $EnvironmentURL,
        [Parameter(Mandatory)]
        [string] $Path
    )
    
    Write-Host -ForegroundColor Green -Object "Deploying $Path"

    $APIBaseURL = "$EnvironmentURL/BC/API/microsoft/automation/beta"

    $Companies = Invoke-RestMethod -Method Get `
        -Uri "$APIBaseURL/companies" `
        -Credential $Credential
    
    $companyId = $Companies.value[0].id
    
    #GetExtensions
    Write-Host -ForegroundColor Green -Object "Current Extensions:"
    $getExtensions = Invoke-RestMethod -Method Get `
        -Uri "$APIBaseURL/companies($companyId)/extensions" `
        -Credential $Credential
    
    $getExtensions.value | Select displayName, publisher, versionMajor, versionMinor, isInstalled, packageId, id | format-table
    
    #Publish Extension
    Write-Host -ForegroundColor Green -Object "Publishing $Path"
    Invoke-RestMethod -Method Patch `
        -Uri "$APIBaseURL/companies($companyId)/extensionUpload(0)/content" `
        -Credential $credential `
        -ContentType "application/octet-stream" `
        -Headers @{"If-Match" = "*" } `
        -InFile $Path | Out-Null

    Get-BCDeploymentStatus -Credential $Credential -EnvironmentURL $EnvironmentURL
}