function Get-AlSymbolFile {
    param(
        [Parameter(Mandatory = $false)]
        [String] $Server = 'http://localhost',
        [Parameter(Mandatory = $false)]
        [String] $Port = "7049",
        [Parameter(Mandatory = $false)]
        [String] $ServerInstance = 'BC',
        [Parameter(Mandatory = $false)]
        [String] $Publisher = 'Microsoft',
        [Parameter(Mandatory = $true)]
        [String] $AppName,
        [Parameter(Mandatory = $true)]
        [String] $VersionText,
        [Parameter(Mandatory = $false)]
        [String] $OutPath = "./alpackages",
        [Parameter(Mandatory = $true)]
        [String] $Authentication,
        [Parameter(Mandatory = $false)]
        [pscredential] $Credential
    )
    Write-Host "Downloading $($Publisher)_$($AppName)_$($VersionText) to $($OutPath)"
    
    if (!(Test-Path $OutPath)) { New-Item $OutPath -ItemType Directory }

    if (!$Port) { $Port = "7049" }
    $url = "$($Server):$($Port)/$($ServerInstance)/dev/packages?publisher=$($Publisher)&appName=$($AppName)&versionText=$($VersionText)"
    
    if ($Authentication -ne 'Windows') {
        $PasswordTemplate = "$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"
        $PasswordBytes = [System.Text.Encoding]::Default.GetBytes($PasswordTemplate)
        $EncodedText = [Convert]::ToBase64String($PasswordBytes)
        
        Write-Host "DownloadURL: $url"
        $Response = Invoke-WebRequest -Method Get -Uri $url -Headers @{ "Authorization" = "Basic $EncodedText" } `    
    }
    else {
        Write-Host "DownloadURL: $url"
        $Response = Invoke-WebRequest -Method Get -Uri $url -UseDefaultCredentials 
    }
    $filename = $Response.Headers.'content-disposition'    
    $filename = [regex]::Matches($filename, 'filename="?(.+.app)').Groups[1].Value
    $stream = [System.IO.StreamWriter]::new((join-path $OutPath $filename))
    $stream.write($Response.Content)
    $Stream.Dispose()
}