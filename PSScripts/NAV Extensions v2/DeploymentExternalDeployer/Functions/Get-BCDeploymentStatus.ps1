
function Get-BCDeploymentStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscredential] $Credential,
        [Parameter(Mandatory)]
        [string] $EnvironmentURL
    )
    $APIBaseURL = "$EnvironmentURL/BC/API/microsoft/automation/beta"

    $Companies = Invoke-RestMethod -Method Get `
        -Uri "$APIBaseURL/companies" `
        -Credential $Credential

    $companyId = $Companies.value[0].id

    Write-Host -ForegroundColor Green -Object "Deployment Status at $APIBaseURL :"
    $extensionDeploymentStatusResponse = Invoke-RestMethod -Method Get `
        -Uri "$APIBaseURL/companies($companyId)/extensionDeploymentStatus" `
        -Credential $credential
            
    $extensionDeploymentStatusResponse.value | Select name, publisher, operationType, status, schedule, appVersion, startedOn | Sort startedOn -Descending | Format-Table
            
}