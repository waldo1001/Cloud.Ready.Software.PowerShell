<#
enter-pssession waldocorevm -Credential (Get-Credential)
#>

. (join-path $PSScriptRoot '_Settings.ps1')

Invoke-Command -ComputerName $DockerHost -Credential (Get-Credential) -ScriptBlock {
    
    docker images --format "{{.Repository}}:{{.Tag}}" | 
        Where-Object {$_ -like "*nav*"} |
            ForEach-Object {docker pull $_}   
    
}

 