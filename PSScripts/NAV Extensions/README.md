# Making development of "Extensions v1" easier
This directory consists of a set of scripts that can make the management of you Extensions easier.  
## Before you begin
Before you begin, copy the files in this folder to a directory that lives together with your App.
Example:
- Create a directory (preferably in your SCM system) with the name of your app, like: C:\GitHub\MyAppsRepo\HelloWorld
- Create a subdirectory that will contain the PowerShell Scripts, like:
c:\GitHub\MyAppsRepo\HelloWorld\PowerShellScripts
- Copy the files in this folder to that new folder.  From this moment, the scripts will co-exist with your app.

## The Scripts
### The Settings Script
File: _Settings.ps1
This is the only file you should change.  All the parameters that the other files will need, are in here.  So it is really important that you change this file according to your app. 

### CreateDEVEnvironment
File: 1_CreateDEVEnvironment.ps1
This script will create a development environment especially for you app.  It will look at the settingsfile toget the 'Original','modified','target'.  And accordingly will create:
- An Original environment (if it doesn't exist yet - you can share this environment for all the apps you're developing on this system)
- A Target(=Test) environment (if it doesn't exist yet - you can share this environment for all the apps you're developing on this system)
- A Modified environment.  This is the environment where you will do your modifications 
The script will use PortSharing by default.

### ApplyDeltas
File: 2_ApplyDeltasInDEV.ps1
Only execute this script when you're setting up a fresh environment.  Basically, this script will import the delta's from the "AppFiles" directory, part of your App.  

### CreatePermissionSets
File: 3_CreatePermissionSets.ps1
PermissionSets should be part of code, not just data in a dev environment.  This script is an example of how to do that.
Because this script is part of your app in your directory, the content of which PermissionSets to create is also part of the app.

### CreateWebServices
File: 3_CreateWebServices.ps1
Same as the Permissionsets: creating web services should be part of the app. 

### Open DEV environment
File: 4_OpenDEVEnvironment.ps1
Just an easy way to open the DEV environment that has been set up in your settingsfile.

### Build And Deploy
File: 5_BuildAndDeployApp.ps1
The most important script of all.  This app will:
- Export Original (if needed)
- Export Modified (or modifiedonly objects, if complete export already exists)
- build deltas
- create the NAVX
- deploy to the target
- Start Target environment
It is created to simulate the "F5" in Visual Studio.

### Backup objects
File: 6_BackupApp.ps1
This script will save all possible exports in a structured way to your directory.  It will create these folders:
- AppFiles: The deltas
- AppFiles_Reverse: The reverse deltas
- Split: the txt-files of all modified objects
- AppName_OnlyModified.txt
- AppName_OnlyModified.fob

## How to begin
Apply these steps:
- Create a directory (preferably in your SCM system) with the name of your app, like: C:\GitHub\MyAppsRepo\HelloWorld
- Create a subdirectory that will contain the PowerShell Scripts, like:
c:\GitHub\MyAppsRepo\HelloWorld\PowerShellScripts
- Copy the files in this folder to that new folder.  From this moment, the scripts will co-exist with your app.
- Modify the Settings-file according to your app
- Run the "CreateDEVEnvironment" script
- Import developments if they exist (in the AppFiles directory - when starting a new app, this won't exist)
- Start your development by adding/changing objects in the Modified-instance.
- When you want to test your developments, run the "Build & Deploy" script.  When finished, it will open a client for you to test
- When you feel comfortable, it's recommended to run the Backup script.

