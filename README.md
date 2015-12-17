# Cloud.Ready.Software.PowerShell
waldo's PowerShell Scripts &amp; Modules

## Modules

- Cloud.Ready.Software.NAV

  This module contains functions that has anything to do with NAV.
  
- Cloud.Ready.Software.PowerShell

  This module contains various PowerShell helper functions.
  
- Cloud.Ready.Software.SQL

  This module contains functions that has anything to do with SQL, like backups, restores, and invoking queries.
  
- Cloud.Ready.Software.Windows

  This module has typical Windows related functions such as zip and unzip, working with streams, file management, ISO files, etc.

## Scripts
The root directory contains many numbered directories. These are scripts that use the modules in various ways to perform various day to day tasks.
You will likely edit or create your own scripts.

## Installation

The source contains a few scripts to help you easily install and configure the PowerShell modules.

### Installing the modules

The main part of the installation is the `InstallModules.ps1` script. It will make the modules available to the system by updating your PSModules-path. On top of that, it will load the modules when you start a new PowerShell session so you don’t need to do it any more.

To install, run the `InstallModules.ps1` script in the `PSModules` directory. It is important that you do this in a PowerShell session running as administrator.

### Create profile in PowerShell ISE

To add some handy menu items in the PowerShell ISE you can use the `CreateProfileInISE.ps1` script in the `PSModules` directory.

Open the PowerShell ISE as an administrator and run the `CreateProfileInISE.ps1` script. Now restart your PowerShell ISE. The new menu items should be available in the Add-ons menu.

### Reload the modules

In case you edit any of the modules you will have to reload the modules (or restart your PowerShell session).

The modules can be reloaded using either the PowerShell ISE add-on menu items or using the `LoadModules.ps1` script in the `PSModules` directory.
