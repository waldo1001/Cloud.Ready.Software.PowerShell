
Function Remove-InvalidFileNameChars {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
      [String]$Name
    )
  
    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
    return ($Name -replace $re)
}

function Download-NAVAppSymbols()
{
    param(
        [string] $ComputerName   = "localhost" ,
        [int]    $NAVDevPort     = 7049,
        [string] $ServerInstance = "DynamicsNAV110",
        [string] $NAVTenant      = "default",
        [string] $AppPublisher,
        [string] $AppName,
        [string] $AppVersion,
        [switch] $UseSSL,
        [string] $OutputPath,
        [PSCredential] $Credential,
        [bool] $BasicAuthentication
    )

    # $Protocol = "http"
    # if ($UseSSL){
    #     $Protocol = "https"
    # }
        
    $UrlBuilder = [System.Text.StringBuilder]::new() 
    #$UrlBuilder.Append("$Protocol`://$ComputerName`:$NAVDevPort/$ServerInstance/dev/packages?") | out-null
    $UrlBuilder.Append("$ComputerName`:$NAVDevPort/$ServerInstance/dev/packages?") | out-null
    $UrlBuilder.Append("publisher=$([System.Web.HTTPUtility]::UrlEncode($AppPublisher))") | out-null
    $UrlBuilder.Append("&appName=$([System.Web.HTTPUtility]::UrlEncode($AppName))") | out-null
    $UrlBuilder.Append("&versionText=$([System.Web.HTTPUtility]::UrlEncode($AppVersion))") | out-null
    $UrlBuilder.Append("&tenant=$([System.Web.HTTPUtility]::UrlEncode($NAVTenant))") | out-null
    
    $Url = $UrlBuilder.ToString()
        
    Write-Host "Downloading NAV Symbols for [$AppName v$AppVersion]" -ForegroundColor Green
    Write-Host "Downloading NAV Symbols from [$Url]" -ForegroundColor Green
    
    $request = [System.Net.WebRequest]::Create($Url)

    if (($null -eq $Credential) -and ($BasicAuthentication -eq $false)){
        $request.UseDefaultCredentials = $true
        Write-Host "Downloading NAV Symbols with Credentials [$($env:UserName)]"
    } 
    
    if (($null -ne $Credential)) {
        if ($BasicAuthentication -eq $false){
            $request.UseDefaultCredentials = $false
            $request.Credentials = $Credential
            Write-Host "Downloading NAV Symbols with Credentials [$($Credential.UserName)]"
        } else {
            $AuthenticationString = "$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"
            $AuthenticationKey    = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($AuthenticationString))
            $AuthenticationHeader = "Basic $($AuthenticationKey)"

            $request.UseDefaultCredentials = $false
            $request.Headers.Add("Authorization", $AuthenticationHeader)

            Write-Host "Downloading NAV Symbols with BasicAuthentication [$($Credential.UserName)]"
        }
    }
    
    $request.AllowAutoRedirect=$false

    Write-Host "##[command]Invoke-RestMethod -Method Get -Uri $Url"

    $response=$request.GetResponse()    
    if ($response.StatusCode -eq "OK")
    {
        $fileName = $response.GetResponseHeader("Content-Disposition").Replace("attachment; filename=","") | Remove-InvalidFileNameChars
        $filePath = Join-Path -Path $OutputPath -ChildPath $fileName

        Write-Host "Saving symbol file [$fileName] to [$OutputPath]" -ForegroundColor Green

        $responseStream = $response.GetResponseStream()

        $output = [System.IO.File]::OpenWrite($filePath)
        $responseStream.CopyTo($output)
        $output.Close()

        $responseStream.Close()
    } 

    return $filePath
}

