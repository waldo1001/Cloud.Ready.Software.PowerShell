. '.\_Settings.ps1'

Invoke-Command -ComputerName $DockerHost -Credential $DockerHostCredentials -UseSSL:$DockerHostUseSSL -SessionOption $DockerHostSessionOption -ScriptBlock {
    param(
        $UpgradeSettings, $ContainerName
    )
    
    Invoke-Command -Session (Get-NavContainerSession -containerName $ContainerName) -ScriptBlock {
        param(
            $UpgradeSettings
        )

        $FinalResult = Join-path $UpgradeSettings.ResultFolder "FinalResult.txt"
        Join-NAVApplicationObjectFile -Source (Join-Path $UpgradeSettings.ResultFolder "MergeResult") -Destination $FinalResult

        
    } -ArgumentList $UpgradeSettings

} -ArgumentList $UpgradeSettings, $ContainerName
