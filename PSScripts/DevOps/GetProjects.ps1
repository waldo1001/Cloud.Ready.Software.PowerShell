# static [string] $ApiVersionV1  = "api-version=1.0"
# static [string] $ApiVersionV2  = "api-version=2.0-preview"
# static [string] $ApiVersionV3  = "api-version=3.0-preview.1"
# static [string] $ApiVersionV4  = "api-version=4.0-preview"


$PAT = 'OmoybmpydHR5Z3lwbHNwejI0NWtiYmFnbDNwaGtqcnBtMjJ4YWJtMmc3b21zcW1vN3Z3YWE='

$Projects = 
Invoke-RestMethod -Method Get `
    -Uri "https://dev.azure.com/msdyn365bc/_apis/projects/?api-version=4.1" `
    -Headers @{
    "Authorization" = "Basic " + " " + $PAT
}
$Projects
$Projects.count
$projects.value 




$PAT = '6chyhhxk4zdrijsdg6a2bfygdna33tvbvzheukq4kbkdv4ebux2a'
$PATBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($PAT))

$Projects = 
Invoke-RestMethod -Method Get `
    -Uri "https://dev.azure.com/msdyn365bc/_apis/projects/?api-version=4.1" `
    -Headers @{
    "Authorization" = "Basic " + " " + $PATBase64 
}

$Projects
$Projects.count
$projects.value 