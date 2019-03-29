$fobfile = Join-Path $env:TEMP "PSTestTool.fob"

Download-File `
    -sourceUrl "https://aka.ms/pstesttoolfob" `
    -destinationFile $fobfile

Import-ObjectsToNavContainer `
    -containerName $containerName `
    -objectsFile $fobfile `
    -sqlCredential $credential


