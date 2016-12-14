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
                $ServerName = "$($ServerName)\$($ServerinstanceDetails.DatabaseInstance)"
            }
            $Database = $ServerinstanceDetails.DatabaseName
        }
    }

    $Arguments = "servername=$ServerName, database=$Database, ntauthentication=yes"
    Write-Host -ForegroundColor Green "Starting the DEV client with Arguments: $Arguments ..."
    Start-Process -FilePath $NavIde -ArgumentList $Arguments 
}

