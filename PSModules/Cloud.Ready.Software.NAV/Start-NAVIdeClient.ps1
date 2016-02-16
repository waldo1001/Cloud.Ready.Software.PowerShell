function Start-NAVIdeClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName=([net.dns]::GetHostName()), 
        [String]$Database
        )

    if ([string]::IsNullOrEmpty($NavIde)) {
        Write-Error "Please load the AMU (NavModelTools) to be able to use this function"
    }

    $Arguments = "servername=$ServerName, database=$Database, ntauthentication=yes"
    Write-Verbose "Starting the DEV client $Arguments ..."
    Start-Process -FilePath $NavIde -ArgumentList $Arguments 
}

