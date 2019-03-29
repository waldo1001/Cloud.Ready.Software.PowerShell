#Load model
$ModuleToolAPIPath = "$env:USERPROFILE\Dropbox\GitHub\Waldo.Model.Tools\Revision.Model.Tools.Library - NoLicense"
import-module (join-path $ModuleToolAPIPath NavModelToolsAPI.dll) -WarningAction SilentlyContinue -ErrorAction Stop

#Check License
Check-License

#Function - ModelToolAPI 

#Copy license to folder

Check-License
