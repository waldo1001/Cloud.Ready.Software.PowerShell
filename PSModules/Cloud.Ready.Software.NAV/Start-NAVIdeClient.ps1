function Start-NAVIdeClient
{
    [cmdletbinding()]
    param(
        [String]$ServerInstance,
        [string]$ServerName=([net.dns]::GetHostName()), 
        [String]$Database
        )
    
    if ([string]::IsNullOrEmpty($NavIde)) {
        Write-Error 'Please load the AMU (NavModelTools) to be able to use this function'
    }

    if (-not $Database){
        $ServerinstanceDetails = Get-NAVServerInstanceDetails -ServerInstance $ServerInstance -ErrorAction SilentlyContinue
        if ($ServerinstanceDetails){
            $ServerName = $ServerinstanceDetails.DatabaseServer
            IF (-not ([String]::IsNullOrEmpty($ServerinstanceDetails.DatabaseInstance))){
                $ServerName = "$($ServerinstanceDetails.DatabaseInstance)\$($ServerName)"
            }
            $Database = $ServerinstanceDetails.DatabaseName
        }
    }

    $Arguments = "servername=$ServerName, database=$Database, ntauthentication=yes"
    Write-Verbose "Starting the DEV client $Arguments ..."
    Start-Process -FilePath $NavIde -ArgumentList $Arguments 
}

