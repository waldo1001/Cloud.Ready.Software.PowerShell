. '.\_Settings.ps1'

$ReleaseSettings.Product = 'Distri'
$ReleaseSettings.LocalPath = "C:\ProgramData\NavContainerHelper\ReleaseProduct\Distri\131\ReleaseDistri131.txt"
$ReleaseSettings.ContainerPath = "C:\ProgramData\NavContainerHelper\ReleaseProduct\Distri\131\ReleaseDistri131.txt"
$ReleaseSettings.ProductVersion = "I13.1" #"IDB1.0"  #'IRM11.0' #'IF7.0'
$ReleaseSettings.ModifiedOnly = $true

switch ($ReleaseSettings.Product) {
    'Food' {    
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'IB', 'SI', 'IF' 
    }
    'Distri' {  
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I' 
    }
    'DistriBouw' {  
        $ReleaseSettings.VersionPrefix = 'NAVW1', 'NAVBE', 'Test', 'I7', 'I8', 'I9', 'I10', 'I11', 'IDB'
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
Release-NCHNAVApplicationObjects `
    -ContainerName $ContainerName `
    -ReleaseSettings $ReleaseSettings


$ReleaseResult.VersionlistCompare | 
    Format-Table -AutoSize

#Start-Process $ReleaseResult.LocalPath