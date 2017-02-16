# Using the Upgrade Scripts

## The easiest way on how to get started:
Apply these steps:
- Copy the "Set-UpgradeSettings.ps1" to a dedicated folder
- Copy the "UpgradeDatabase.ps1" to that same folder
- Change the settings in the settingsfile.
- Run the UgradeDatabase.ps1 script.  It will get the settings as the first step.

## When you want to use one environment for multiple upgrades:
To make sure you don't have to export objects more than necessary, the idea is to re-use folders.
To setup your environment for this, run the "InitEnvironment.ps1" script.  Be careful, also this one will look at your settings-file, so make sure you do these steps:
- Copy the "Set-UpgradeSettings.ps1" to a dedicated folder
- Copy the "InitEnvironment.ps1" script to that dedicated folder
- Change the settings in the settingsfile.
- Run the InitEnvironment.ps1 script.  It will get the settings as the first step.
- Now, populate the folders with the object files  in:
  - ObjectLibary (typically the originals and targets)
  - Modified (typically the customers version of the objects)
- to start the upgrade, just create a new folder in the "scriptfolder" directory (name your upgrade), and perform the steps above (in section "the easist way on how to get started")
