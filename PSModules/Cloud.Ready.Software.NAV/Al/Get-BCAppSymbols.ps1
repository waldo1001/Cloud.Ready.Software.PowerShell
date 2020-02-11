function Get-BCAppSymbols() {
    param(
        [string] $Server = "http://localhost" ,
        [int]    $Port = 0,
        [string] $ServerInstance = "BC",
        [string] $Tenant = "default",
        [string] $AppPublisher,
        [string] $AppName,
        [string] $AppVersion,
        [string] $OutputPath,
        [PSCredential] $Credential,
        [bool] $BasicAuthentication
    )

    if ($Port -eq 0) { $Port = 7049 }
        
    $UrlBuilder = [System.Text.StringBuilder]::new() 
    $UrlBuilder.Append("$Server`:$Port/$ServerInstance/dev/packages?") | out-null
    $UrlBuilder.Append("publisher=$([System.Web.HTTPUtility]::UrlEncode($AppPublisher))") | out-null
    $UrlBuilder.Append("&appName=$([System.Web.HTTPUtility]::UrlEncode($AppName))") | out-null
    $UrlBuilder.Append("&versionText=$([System.Web.HTTPUtility]::UrlEncode($AppVersion))") | out-null
    $UrlBuilder.Append("&tenant=$([System.Web.HTTPUtility]::UrlEncode($Tenant))") | out-null
    
    $Url = $UrlBuilder.ToString()
        
    Write-Host "*** Downloading NAV Symbols for [$AppName v$AppVersion]" -ForegroundColor Green
    Write-Host "*** Downloading NAV Symbols from [$Url]" -ForegroundColor Green
    
    $request = [System.Net.WebRequest]::Create($Url)

    if (($null -eq $Credential) -and ($BasicAuthentication -eq $false)) {
        $request.UseDefaultCredentials = $true
        Write-Host "*** Downloading NAV Symbols with Credentials [$($env:UserName)]"
    } 
    
    if (($null -ne $Credential)) {
        if ($BasicAuthentication -eq $false) {
            $request.UseDefaultCredentials = $false
            $request.Credentials = $Credential
            Write-Host "*** Downloading NAV Symbols with Credentials [$($Credential.UserName)]"
        }
        else {
            $AuthenticationString = "$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"
            $AuthenticationKey = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($AuthenticationString))
            $AuthenticationHeader = "Basic $($AuthenticationKey)"

            $request.UseDefaultCredentials = $false
            $request.Headers.Add("Authorization", $AuthenticationHeader)

            Write-Host "*** Downloading NAV Symbols with BasicAuthentication [$($Credential.UserName)]"
        }
    }
    
    $request.AllowAutoRedirect = $false

    Write-Host "##[command]Invoke-RestMethod -Method Get -Uri $Url"

    $response = $request.GetResponse()    
    if ($response.StatusCode -eq "OK") {
        $fileName = $response.GetResponseHeader("Content-Disposition").Replace("attachment; filename=", "") | Remove-InvalidFileNameChars
        $filePath = Join-Path -Path $OutputPath -ChildPath $fileName

        Write-Host "*** Saving symbol file [$fileName] to [$OutputPath]" -ForegroundColor Green

        $responseStream = $response.GetResponseStream()

        $output = [System.IO.File]::OpenWrite($filePath)
        $responseStream.CopyTo($output)
        $output.Close()

        $responseStream.Close()
    } 

    return $filePath
}

