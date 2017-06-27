<#
Install New DEV experience on a local environment
Step 1: Execute this script on the Azure-VM
Step 2: Copy the the files to a local machine in the folder 'C:\_Installs'
Step 3: Execute the script "InstallOnLocalEnvironment.ps1" on the local environment.
#>

Find-Module | where author -eq waldo | Install-Module -Force #Make sure you trust my modules
Import-Module -Name Cloud.Ready.Software.NAV

#DVD
Create-FolderIfNotExist -MyFolder 'C:\DOWNLOAD\' | Out-Null
New-ISOFileFromFolder -FilePath 'C:\NAVDVD\US' -Name 'NAVDVD' -ResultFullFileName 'C:\DOWNLOAD\NAVDVD.iso'

#DEVTools
Get-ChildItem -Path 'C:\DEMO\New Developer Experience' | Create-ZipFileFromPipedItems -zipfilename 'C:\DOWNLOAD\NewDEVTools.zip'

Start 'C:\DOWNLOAD\'
