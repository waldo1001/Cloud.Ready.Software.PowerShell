$cred = Get-Credential

Get-AlSymbolFile `
    -Publisher 'Microsoft' `
    -AppName 'Application' `
    -AppVersion '11.0.0.0' `
    -DownloadFolder c:\Temp `
    -Authentication NavUserPassword `
    -Credential $cred  

Get-AlSymbolFile `
    -Publisher 'Microsoft' `
    -AppName 'System' `
    -AppVersion '11.0.0.0' `
    -DownloadFolder c:\Temp `
    -Authentication NavUserPassword `
    -Credential $cred 

start C:\temp