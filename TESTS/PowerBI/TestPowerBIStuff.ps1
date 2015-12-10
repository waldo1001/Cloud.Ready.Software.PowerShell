Set-ExecutionPolicy -ExecutionPolicy Unrestricted
import-module 'C:\Users\Eric\OneDrive for Business 1\$TFS\PowerShellScripts\8. PowerBI\PowerBIPS' -Force

$MyToken = Get-PBIAuthToken

Test-PBIDataSet -authToken $Mytoken -name "4b. Sales Dashboard - With Power View"

$MyDataset = Get-PBIDataSet -authToken $MyToken -name "4b. Sales Dashboard - With Power View" 


