. '.\_Settings.ps1'

$ReleaseSettings.Product = 'Distri'
$ReleaseSettings.LocalPath = "C:\temp\DistriRelease\Release 11.2\DistriDEV.txt"
$ReleaseSettings.ProductVersion = 'I11.2'
$ReleaseSettings.ModifiedOnly = $true

switch ($ReleaseSettings.Product) {
    'Food' {    
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'I7', 'I8', 'IB', 'SI', 'IF' 
    }
    'Distri' {  
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I' 
    }
    'Base' {
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'IB' 
    }
    Default {
        write-error "Unknown product '$($ReleaseSettings.Product)'"
        break
    }
}

$ReleaseResult = 
Release-RDHNAVApplicationObjects `
    -DockerHost $DockerHost `
    -DockerHostCredentials $DockerHostCredentials `
    -DockerHostUseSSL:$DockerHostUseSSL `
    -DockerHostSessionOption $DockerHostSessionOption `
    -ContainerName $ContainerName `
    -ReleaseSettings $ReleaseSettings


$ReleaseResult.VersionlistCompare | 
    Format-Table -AutoSize

Start-Process $ReleaseResult.LocalPath