. '.\_Settings.ps1'

$ReleaseSettings.Product = 'DistriBouw'
$ReleaseSettings.LocalPath = "C:\temp\DistriBouwRelease\AllModified.txt"
$ReleaseSettings.ProductVersion = "IDB1.0" #"I11.3" #'IRM11.0' #'IF7.0'
$ReleaseSettings.ModifiedOnly = $true

switch ($ReleaseSettings.Product) {
    'Food' {    
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'IB', 'SI', 'IF' 
    }
    'Distri' {  
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I' 
    }
    'DistriBouw' {  
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'I10','I11', 'IDB'
    }
    'Base' {
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'IB' 
    }
    'Rental' {
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'IB', 'EQM', 'IRM' 
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