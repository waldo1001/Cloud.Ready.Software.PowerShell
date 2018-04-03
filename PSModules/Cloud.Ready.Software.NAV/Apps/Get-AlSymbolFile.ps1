function Get-AlSymbolFile {
    param(
        
        [Parameter(Mandatory = $false)]
        [String] $Publisher = 'Microsoft',
        [Parameter(Mandatory = $true)]
        [String] $AppName,
        [Parameter(Mandatory = $true)]
        [String] $AppVersion,
        [Parameter(Mandatory = $true)]
        [String] $DownloadFolder,
        [ValidateSet('Windows', 'NavUserPassword')]
        [Parameter(Mandatory = $true)]
        [String] $Authentication,
        [Parameter(Mandatory = $true)]
        [pscredential] $Credential
    )

    $TargetFile = Join-Path -Path $DownloadFolder -ChildPath "$($Publisher)_$($AppName)_$($AppVersion).app"

    if ($Authentication = 'NavUserPassword') {
        $PasswordTemplate = "$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"
        $PasswordBytes = [System.Text.Encoding]::Default.GetBytes($PasswordTemplate)
        $EncodedText = [Convert]::ToBase64String($PasswordBytes)
        
        $null = Invoke-RestMethod `
                    -Method get `
                    -Uri "http://devpreview:7049/nav/dev/packages?publisher=$($Publisher)&appName=$($AppName)&versionText=$($AppVersion)&tenant=default" `
                    -Headers @{ "Authorization" = "Basic $EncodedText"} `
                    -OutFile $TargetFile
        
    }  else {
        $null = Invoke-RestMethod `
                    -Method get `
                    -Uri "http://devpreview:7049/nav/dev/packages?publisher=$($Publisher)&appName=$($AppName)&versionText=$($AppVersion)&tenant=default" `
                    -Credential $Credential `
                    -OutFile $TargetFile        
    }

    Get-Item $TargetFile
}