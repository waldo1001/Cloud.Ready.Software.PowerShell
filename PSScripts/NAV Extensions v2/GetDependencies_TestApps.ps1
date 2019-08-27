#A script to quickly add a collection with fake apps, to test the dependency script

$AllApps = @()

$AllApps += [PSCustomObject]@{
    AppId                = "B"
    ProcessOrder         = 1                            
    Dependencies         = [PSCustomObject]@()
    NumberOfDependencies = 0
    #Path         = $AppFile.FullName
}

$AllApps += [PSCustomObject]@{
    AppId                = "D"
    ProcessOrder         = 1                            
    Dependencies         = [PSCustomObject]@()
    NumberOfDependencies = 0
    #Path         = $AppFile.FullName
}

$AllApps += [PSCustomObject]@{
    AppId                = "A"
    ProcessOrder         = 1                            
    Dependencies         = @([PSCustomObject]@{
            AppId = "B" 
            Name  = "B"
        },
        [PSCustomObject]@{
            AppId = "C" 
            Name  = "C"
        })
    NumberOfDependencies = 2
    #Path         = $AppFile.FullName
}

$AllApps += [PSCustomObject]@{
    AppId                = "E"
    ProcessOrder         = 1                            
    Dependencies         = @([PSCustomObject]@{
            AppId = "A" 
            Name  = "A"
        })
    NumberOfDependencies = 1
    #Path         = $AppFile.FullName
}
$AllApps += [PSCustomObject]@{
    AppId                = "C"
    ProcessOrder         = 1                            
    Dependencies         = @([PSCustomObject]@{
            AppId = "D" 
            Name  = "D"
        })
    NumberOfDependencies = 1
    #Path         = $AppFile.FullName
}