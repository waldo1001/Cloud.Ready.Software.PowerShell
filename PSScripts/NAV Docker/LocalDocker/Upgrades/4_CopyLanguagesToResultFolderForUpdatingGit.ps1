. '.\_Settings.ps1'

Invoke-Command -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption -ScriptBlock {
    param(
        $UpgradeSettings, $ContainerName
    )
    
    Invoke-Command -Session (Get-NavContainerSession -containerName $ContainerName) -ScriptBlock {
        param(
            $UpgradeSettings
        )

        $ResultWithLanguages = Join-Path $UpgradeSettings.ResultFolder "ResultWithLanguages"

        Write-Host "From: $($ResultWithLanguages)\*.txt"
        Write-Host "To:   $(Join-Path $UpgradeSettings.ResultFolder "MergeResult")"

        Copy-Item -Path "$ResultWithLanguages\*.txt" -Destination (Join-Path $UpgradeSettings.ResultFolder "MergeResult") -Recurse
        
    } -ArgumentList $UpgradeSettings

} -ArgumentList $UpgradeSettings, $ContainerName
