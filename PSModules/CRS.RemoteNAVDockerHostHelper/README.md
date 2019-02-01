# CRS.DockerHostHelper
This module is quite similar to the navcontainerhelper, but one level up: it also remotes into the dockerhost.

So, if you don't have your docker available on the machine you might be developing extensions, you might have to log into the dockerhost first, where you can again remote into the navcontainerhelper.

That means that all these functions will typically have two nested "Invoke-Commands", like:
```PowerShell
    ...

    Invoke-Command -ComputerName $DockerHost -UseSSL -Credential $DockerHostCredentials -ScriptBlock {
        param(
            $ContainerName
        )
    
        Invoke-ScriptInNavContainer -ContainerName $ContainerName -scriptblock {
            param(
                ...
            )
            
            ...                
        }  -ArgumentList $CreateWebServicesKey,$Username,$Password        
    } -ArgumentList $ContainerName,$CreateWebServicesKey,$Username,$Password
```

This also means the module is higly dependent on the 'navcontainerhelper' module by Freddy Kristiansen.

## Rule of engagement
- All functions get its own file
- No files in the root folder
- Name should be like Powershell CmdLets: Verb-Noun
- All Nouns should start with "CRS"
  