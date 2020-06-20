function Get-BCArtifactUrl {
    [CmdletBinding()]
    param (
        [ValidateSet('OnPrem', 'Sandbox')]
        [String] $Type = 'Sandbox',
        [String] $language,
        [String] $Version,
        [ValidateSet('All', 'Latest')]
        [String] $Select = 'All',
        [String] $StorageAccountName = 'bcartifacts'
    )
    
    $BaseUrl = "https://$($StorageAccountName.ToLower()).azureedge.net/$($Type.ToLower())/?comp=list&limit=10"
    
    if (!([string]::IsNullOrEmpty($version))) {
        $BaseUrl += "&prefix=$($Version)"
    }
    
    $Response = Invoke-RestMethod -Method Get -Uri $BaseUrl
    $Artifacts = ([xml] $Response.ToString().Substring($Response.IndexOf("<EnumerationResults"))).EnumerationResults.Blobs.Blob
 

    if (!([string]::IsNullOrEmpty($language))) {
        $Artifacts = $Artifacts | Where-Object { $_.Name.EndsWith($language) }
    }

    switch ($Select) {
        'All' {  
            $Artifacts = $Artifacts
        }
        'Latest' { 
            $Artifacts = $Artifacts | 
            Sort-Object { [Version]($_.name.Split('/')[0]) } | 
            Select-Object -Last 1   
        }
        Default {
            Write-Error "Unknown value for parameter 'Select'."
            return
        }
    }

    $Artifacts.Url
    
}

